local VarDigits,
	VarStartDigits,
	Keywords,
	ExtGlobals,
	CreateLuaParser,
	AddVariableInfo,
	FoldConstants,
	StripAst,
	FormatAst,
	PrintAst

do
	local lookData = require('lookups')
	local minify = require('minify')

	VarDigits = lookData.AllIdentChars
	VarStartDigits = lookData.AllIdentStartChars
	Keywords = lookData.Keywords
	ExtGlobals = lookData.GlobalRenameIgnore
	CreateLuaParser = minify.CreateLuaParser
	AddVariableInfo = minify.AddVariableInfo
	FoldConstants = minify.FoldConstants
	StripAst = minify.StripAst
	FormatAst = minify.FormatAst
	PrintAst = minify.PrintAst
end

local function indexToVarName(index)
	local id = ''
	local vd = index % #VarStartDigits
	index = (index - vd) / #VarStartDigits
	id = id .. VarStartDigits[vd + 1]
	while index > 0 do
		local d = index % #VarDigits
		index = (index - d) / #VarDigits
		id = id .. VarDigits[d + 1]
	end
	return id
end

local function MinifyVariables(globalScope, rootScope)
	-- externalGlobals is a set of global variables that have not been assigned to, that is
	-- global variables defined "externally to the script". We are not going to be renaming
	-- those, and we have to make sure that we don't collide with them when renaming
	-- things so we keep track of them in this set.
	local externalGlobals = {}

	for _, var in pairs(ExtGlobals) do
		externalGlobals[var] = true
	end

	-- First we want to rename all of the variables to unique temoraries, so that we can
	-- easily use the scope::GetVar function to check whether renames are valid.
	local temporaryIndex = 0
	for _, var in pairs(globalScope) do
		if var.AssignedTo then
			var:Rename('_TMP_' .. temporaryIndex .. '_')
			temporaryIndex = temporaryIndex + 1
		else
			-- Not assigned to, external global
			externalGlobals[var.Name] = true
		end
	end

	-- Now we go through renaming, first do globals, we probably want them
	-- to have shorter names in general.
	-- TODO: Rename all vars based on frequency patterns, giving variables
	--       used more shorter names.
	local nextFreeNameIndex = 0
	for _, var in pairs(globalScope) do
		if var.AssignedTo then
			local varName
			repeat
				varName = indexToVarName(nextFreeNameIndex)
				nextFreeNameIndex = nextFreeNameIndex + 1
			until not Keywords[varName] and not externalGlobals[varName]
			var:Rename(varName)
		end
	end

	-- Now rename all local vars
	rootScope.FirstFreeName = nextFreeNameIndex
	local function doRenameScope(scope)
		for _, var in pairs(scope.VariableList) do
			local varName
			repeat
				varName = indexToVarName(scope.FirstFreeName)
				scope.FirstFreeName = scope.FirstFreeName + 1
			until not Keywords[varName] and not externalGlobals[varName]
			var:Rename(varName)
		end
		for _, childScope in pairs(scope.ChildScopeList) do
			childScope.FirstFreeName = scope.FirstFreeName
			doRenameScope(childScope)
		end
	end
	doRenameScope(rootScope)
end

local function MinifyVariables_2(globalScope, rootScope)
	-- Variable names and other names that are fixed, that we cannot use
	-- Either these are Lua keywords, or globals that are not assigned to,
	-- that is environmental globals that are assigned elsewhere beyond our
	-- control.
	local globalUsedNames = {}
	for kw, _ in pairs(Keywords) do
		globalUsedNames[kw] = true
	end

	-- Gather a list of all of the variables that we will rename
	local allVariables = {}
	local allLocalVariables = {}
	do
		-- Add applicable globals
		for _, var in pairs(globalScope) do
			if var.AssignedTo then
				-- We can try to rename this global since it was assigned to
				-- (and thus presumably initialized) in the script we are
				-- minifying.
				table.insert(allVariables, var)
			else
				-- We can't rename this global, mark it as an unusable name
				-- and don't add it to the nename list
				globalUsedNames[var.Name] = true
			end
		end

		-- Recursively add locals, we can rename all of those
		local function addFrom(scope)
			for _, var in pairs(scope.VariableList) do
				table.insert(allVariables, var)
				table.insert(allLocalVariables, var)
			end
			for _, childScope in pairs(scope.ChildScopeList) do
				addFrom(childScope)
			end
		end
		addFrom(rootScope)
	end

	-- Add used name arrays to variables
	for _, var in pairs(allVariables) do
		var.UsedNameArray = {}
	end

	-- Sort the least used variables first
	table.sort(
		allVariables,
		function(a, b)
			return #a.RenameList < #b.RenameList
		end
	)

	-- Lazy generator for valid names to rename to
	local nextValidNameIndex = 0
	local varNamesLazy = {}
	local function varIndexToValidVarName(i)
		local name = varNamesLazy[i]
		if not name then
			repeat
				name = indexToVarName(nextValidNameIndex)
				nextValidNameIndex = nextValidNameIndex + 1
			until not globalUsedNames[name]
			varNamesLazy[i] = name
		end
		return name
	end

	-- For each variable, go to rename it
	for _, var in pairs(allVariables) do
		-- Lazy... todo: Make theis pair a proper for-each-pair-like set of loops
		-- rather than using a renamed flag.
		var.Renamed = true

		-- Find the first unused name
		local i = 1
		while var.UsedNameArray[i] do
			i = i + 1
		end

		-- Rename the variable to that name
		var:Rename(varIndexToValidVarName(i))

		if var.Scope then
			-- Now we need to mark the name as unusable by any variables:
			--  1) At the same depth that overlap lifetime with this one
			--  2) At a deeper level, which have a reference to this variable in their lifetimes
			--  3) At a shallower level, which are referenced during this variable's lifetime
			for _, otherVar in pairs(allVariables) do
				if not otherVar.Renamed then
					if not otherVar.Scope or otherVar.Scope.Depth < var.Scope.Depth then
						-- Check Global variable (Which is always at a shallower level)
						--  or
						-- Check case 3
						-- The other var is at a shallower depth, is there a reference to it
						-- durring this variable's lifetime?
						for _, refAt in pairs(otherVar.ReferenceLocationList) do
							if refAt >= var.BeginLocation and refAt <= var.ScopeEndLocation then
								-- Collide
								otherVar.UsedNameArray[i] = true
								break
							end
						end
					elseif otherVar.Scope.Depth > var.Scope.Depth then
						-- Check Case 2
						-- The other var is at a greater depth, see if any of the references
						-- to this variable are in the other var's lifetime.
						for _, refAt in pairs(var.ReferenceLocationList) do
							if refAt >= otherVar.BeginLocation and refAt <= otherVar.ScopeEndLocation then
								-- Collide
								otherVar.UsedNameArray[i] = true
								break
							end
						end
					else --otherVar.Scope.Depth must be equal to var.Scope.Depth
						-- Check case 1
						-- The two locals are in the same scope
						-- Just check if the usage lifetimes overlap within that scope. That is, we
						-- can shadow a local variable within the same scope as long as the usages
						-- of the two locals do not overlap.
						if var.BeginLocation < otherVar.EndLocation and var.EndLocation > otherVar.BeginLocation then
							otherVar.UsedNameArray[i] = true
						end
					end
				end
			end
		else
			-- This is a global var, all other globals can't collide with it, and
			-- any local variable with a reference to this global in it's lifetime
			-- can't collide with it.
			for _, otherVar in pairs(allVariables) do
				if not otherVar.Renamed then
					if otherVar.Type == 'Global' then
						otherVar.UsedNameArray[i] = true
					elseif otherVar.Type == 'Local' then
						-- Other var is a local, see if there is a reference to this global within
						-- that local's lifetime.
						for _, refAt in pairs(var.ReferenceLocationList) do
							if refAt >= otherVar.BeginLocation and refAt <= otherVar.ScopeEndLocation then
								-- Collide
								otherVar.UsedNameArray[i] = true
								break
							end
						end
					else
						assert(false, 'unreachable')
					end
				end
			end
		end
	end

	-- --
	-- print("Total Variables: "..#allVariables)
	-- print("Total Range: "..rootScope.BeginLocation.."-"..rootScope.EndLocation)
	-- print("")
	-- for _, var in pairs(allVariables) do
	-- 	io.write("`"..var.Name.."':\n\t#symbols: "..#var.RenameList..
	-- 		"\n\tassigned to: "..tostring(var.AssignedTo))
	-- 	if var.Type == 'Local' then
	-- 		io.write("\n\trange: "..var.BeginLocation.."-"..var.EndLocation)
	-- 		io.write("\n\tlocal type: "..var.Info.Type)
	-- 	end
	-- 	io.write("\n\n")
	-- end

	-- -- First we want to rename all of the variables to unique temoraries, so that we can
	-- -- easily use the scope::GetVar function to check whether renames are valid.
	-- local temporaryIndex = 0
	-- for _, var in pairs(allVariables) do
	-- 	var:Rename('_TMP_'..temporaryIndex..'_')
	-- 	temporaryIndex = temporaryIndex + 1
	-- end

	-- For each variable, we need to build a list of names that collide with it

	--
	--error()
end

local function BeautifyVariables(globalScope, rootScope)
	local externalGlobals = {}

	for _, var in pairs(globalScope) do
		if not var.AssignedTo then
			externalGlobals[var.Name] = true
		end
	end

	local localNumber = 1
	local globalNumber = 1

	local function setVarName(var, name)
		var.Name = name
		for _, setter in pairs(var.RenameList) do
			setter(name)
		end
	end

	for _, var in pairs(globalScope) do
		if var.AssignedTo then
			local name

			repeat
				name = 'G_' .. globalNumber .. '_'
				globalNumber = globalNumber + 1
			until not externalGlobals[name]

			setVarName(var, name)
		end
	end

	local function modify(scope)
		for _, var in pairs(scope.VariableList) do
			local name = 'L_' .. localNumber .. '_'
			if var.Info.Type == 'Argument' then
				name = name .. 'arg' .. var.Info.Index
			elseif var.Info.Type == 'LocalFunction' then
				name = name .. 'func'
			elseif var.Info.Type == 'ForRange' then
				name = name .. 'forvar' .. var.Info.Index
			end
			setVarName(var, name)
			localNumber = localNumber + 1
		end
		for _, subscope in pairs(scope.ChildScopeList) do
			modify(subscope)
		end
	end
	modify(rootScope)
end

local source
local files = {}
local flags = {}
local usage_err

do -- prepare program
	local usage = {}
	local info = {
		{'help', 'Show the help message and exit'},
		{'minify', 'Trim extra whitespace'},
		{'beautify', 'Format the code'},
		{'fold', 'Fold arithmetic and unary operations'},
		{'small', 'Minify the variable names'},
		{'smaller', 'Minify the variable names based on scoping'},
		{'pretty', 'Beautify the variable names'}
	}

	for _, flag in ipairs(info) do
		local name = flag[1]

		flags[name] = false
		table.insert(usage, string.format('\t--%-10s@ %s', name, flag[2]))
	end

	function usage_err(err)
		error(err .. '\nusage: [options] inputs > output\n' .. table.concat(usage, '\n'), 0)
	end
end

do -- process command line arguments
	local args = {...}

	local function readFlag(str)
		if flags[str] == nil then
			usage_err('unrecognized option `' .. str .. '`')
		else
			flags[str] = true
		end
	end

	for _, arg in ipairs(args) do
		if arg:sub(1, 2) == '--' then
			readFlag(arg:sub(3))
		else
			table.insert(files, arg)
		end
	end

	if flags.help then
		usage_err('showing help')
	elseif #files == 0 then
		usage_err('no input files provided')
	end
end

do -- read files
	local sources = {}

	for _, name in ipairs(files) do
		local handle, err = io.open(name, 'rb')

		if not handle then
			usage_err(err)
		else
			table.insert(sources, handle:read('*all'))
		end

		handle:close()
	end

	source = table.concat(sources, '\n')
end

do -- run program
	local ast = CreateLuaParser(source)
	local global_scope, root_scope = AddVariableInfo(ast)

	if flags.fold then
		FoldConstants(ast)
	end

	if flags.small then
		MinifyVariables(global_scope, root_scope)
	elseif flags.smaller then
		MinifyVariables_2(global_scope, root_scope)
	elseif flags.pretty then
		BeautifyVariables(global_scope, root_scope)
	end

	if flags.minify then
		StripAst(ast)
	elseif flags.beautify then
		FormatAst(ast)
	end

	PrintAst(ast)
end

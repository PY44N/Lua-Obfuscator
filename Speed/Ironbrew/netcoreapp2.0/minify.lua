--[[
MIT License

Copyright (c) 2017 Mark Langen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local methodList = require('methods')
local WhiteChars,
	CharacterForEscape,
	AllIdentChars,
	AllIdentStartChars,
	Digits,
	EqualSymbols,
	HexDigits,
	Symbols,
	Keywords,
	BlockFollowKeyword,
	UnopSet,
	BinopSet,
	BinaryPriority,
	UnaryPriority,
	lookupify

do -- Load in the lookup data
	local lookData = require('lookups')

	WhiteChars = lookData.WhiteChars
	CharacterForEscape = lookData.CharacterForEscape
	AllIdentChars = lookData.AllIdentChars
	AllIdentStartChars = lookData.AllIdentStartChars
	Digits = lookData.Digits
	EqualSymbols = lookData.EqualSymbols
	HexDigits = lookData.HexDigits
	Symbols = lookData.Symbols
	Keywords = lookData.Keywords
	BlockFollowKeyword = lookData.BlockFollowKeyword
	UnopSet = lookData.UnopSet
	BinopSet = lookData.BinopSet
	BinaryPriority = lookData.BinaryPriority
	UnaryPriority = lookData.UnaryPriority
	lookupify = lookData.lookupify
end

local function IsTableNewlined(tb)
	local c = 0
	for _ in pairs(tb) do
		c = c + 1
		if c == 2 then
			break
		end
	end
	return c > 1
end

local function FormatTableInt(tb, atIndent, ignoreFunc)
	if tb.Print then
		return tb.Print()
	end

	atIndent = atIndent or 0

	local useNewlines = IsTableNewlined(tb)
	local baseIndent = useNewlines and string.rep('    ', atIndent+1) or ''
	local out = "{"..(useNewlines and '\n' or '')

	for k, v in pairs(tb) do
		local ttv = type(v)
		if ttv ~= 'function' and not ignoreFunc(k) then
			local ttk = type(k)

			out = out .. baseIndent

			if ttk == 'string' then
				if k:match("^[A-Za-z_][A-Za-z0-9_]*$") then
					out = out..k.." = "
				else
					out = out.."[\""..k.."\"] = "
				end
			elseif ttk ~= 'number' then
				out = out.."["..tostring(k).."] = "
			end

			if ttv == 'string' then
				out = out.."\""..v.."\""
			elseif ttv == 'number' then
				out = out..v
			elseif ttv == 'table' then
				out = out..FormatTableInt(v, atIndent+(useNewlines and 1 or 0), ignoreFunc)
			else
				out = out..tostring(v)
			end
			if next(tb, k) then
				out = out..","
			end
			if useNewlines then
				out = out..'\n'
			end
		end
	end
	out = out..(useNewlines and string.rep('    ', atIndent) or '').."}"
	return out
end

local function FormatTable(tb, ignoreFunc)
	ignoreFunc = ignoreFunc or function()
		return false
	end
	return FormatTableInt(tb, 0, ignoreFunc)
end

-- Eof, Ident, Keyword, Number, String, Symbol

local function CreateLuaTokenStream(text)
	-- Tracking for the current position in the buffer, and
	-- the current line / character we are on.
	local p = 1

	-- Output buffer for tokens
	local tokenBuffer = {}

	-- Get a character, or '' if at eof
	local function look(n)
		n = p + (n or 0)
		return text:sub(n, n)
	end
	local function get()
		local c = text:sub(p, p)
		p = p + 1
		return c
	end

	-- Error
	local olderr = error
	local function error(str)
		local q = 1
		local line = 1
		local char = 1
		while q <= p do
			if text:sub(q, q) == '\n' then
				line = line + 1
				char = 1
			else
				char = char + 1
			end
			q = q + 1
		end
		for _, token in pairs(tokenBuffer) do
			print(token.Type.."<"..token.Source..">")
		end
		olderr("file<"..line..":"..char..">: "..str)
	end

	-- Consume a long data with equals count of `eqcount'
	local function longdata(eqcount)
		while true do
			local c = get()
			if c == '' then
				error("Unfinished long string.")
			elseif c == ']' then
				local done = true -- Until contested
				for _ = 1, eqcount do
					if look() == '=' then
						p = p + 1
					else
						done = false
						break
					end
				end
				if done and get() == ']' then
					return
				end
			end
		end
	end

	-- Get the opening part for a long data `[` `=`* `[`
	-- Precondition: The first `[` has been consumed
	-- Return: nil or the equals count
	local function getopen()
		local startp = p
		while look() == '=' do
			p = p + 1
		end
		if look() == '[' then
			p = p + 1
			return p - startp - 1
		else
			p = startp
			return nil
		end
	end

	-- Add token
	local whiteStart = 1
	local tokenStart = 1
	local function token(type)
		local tk = {
			Type = type;
			LeadingWhite = text:sub(whiteStart, tokenStart-1);
			Source = text:sub(tokenStart, p-1);
		}
		table.insert(tokenBuffer, tk)
		whiteStart = p
		tokenStart = p
		return tk
	end

	-- Parse tokens loop
	while true do
		-- Mark the whitespace start
		whiteStart = p

		-- Get the leading whitespace + comments
		while true do
			local c = look()
			if c == '' then
				break
			elseif c == '-' then
				if look(1) == '-' then
					p = p + 2
					-- Consume comment body
					if look() == '[' then
						p = p + 1
						local eqcount = getopen()
						if eqcount then
							-- Long comment body
							longdata(eqcount)
						else
							-- Normal comment body
							while true do
								local c2 = get()
								if c2 == '' or c2 == '\n' then
									break
								end
							end
						end
					else
						-- Normal comment body
						while true do
							local c2 = get()
							if c2 == '' or c2 == '\n' then
								break
							end
						end
					end
				else
					break
				end
			elseif WhiteChars[c] then
				p = p + 1
			else
				break
			end
		end
		-- local leadingWhite = text:sub(whiteStart, p-1) -- unused(?)

		-- Mark the token start
		tokenStart = p

		-- Switch on token type
		local c1 = get()
		if c1 == '' then
			-- End of file
			token('Eof')
			break
		elseif c1 == '\'' or c1 == '\"' then
			-- String constant
			while true do
				local c2 = get()
				if c2 == '\\' then
					local c3 = get()
					if tonumber(c3) then -- Reru fix
						for _ = 1, 2 do
							c3 = c3 .. look()

							if tonumber(c3) then
								get()
								if tonumber(c3) > 255 then
									error("Non representable character escape `" .. c3 .. "`.")
								end
							else
								break
							end
						end
					else
						local esc = CharacterForEscape[c3]
						if not esc then
							error("Invalid Escape Sequence `"..c3.."`.")
						end
					end
				elseif c2 == c1 then
					break
				end
			end
			token('String')
		elseif AllIdentStartChars[c1] then
			-- Ident or Keyword
			while AllIdentChars[look()] do
				p = p + 1
			end
			if Keywords[text:sub(tokenStart, p-1)] then
				token('Keyword')
			else
				token('Ident')
			end
		elseif Digits[c1] or (c1 == '.' and Digits[look()]) then
			-- Number
			if c1 == '0' and look() == 'x' then
				p = p + 1
				-- Hex number
				while HexDigits[look()] do
					p = p + 1
				end
			else
				-- Normal Number
				while Digits[look()] do
					p = p + 1
				end
				if look() == '.' then
					-- With decimal point
					p = p + 1
					while Digits[look()] do
						p = p + 1
					end
				end
				if look() == 'e' or look() == 'E' then
					-- With exponent
					p = p + 1
					if look() == '-' then
						p = p + 1
					end
					while Digits[look()] do
						p = p + 1
					end
				end
			end
			token('Number')
		elseif c1 == '[' then
			-- '[' Symbol or Long String
			local eqCount = getopen()
			if eqCount then
				-- Long string
				longdata(eqCount)
				token('String')
			else
				-- Symbol
				token('Symbol')
			end
		elseif c1 == '.' then
			-- Greedily consume up to 3 `.` for . / .. / ... tokens
			if look() == '.' then
				get()
				if look() == '.' then
					get()
				end
			end
			token('Symbol')
		elseif EqualSymbols[c1] then
			if look() == '=' then
				p = p + 1
			end
			token('Symbol')
		elseif Symbols[c1] then
			token('Symbol')
		else
			error("Bad symbol `"..c1.."` in source.")
		end
	end
	return tokenBuffer
end

local function CreateLuaParser(text)
	-- Token stream and pointer into it
	local tokens = CreateLuaTokenStream(text)
	-- for _, tok in pairs(tokens) do
	-- 	print(tok.Type..": "..tok.Source)
	-- end
	local p = 1

	local function get()
		local tok = tokens[p]
		if p < #tokens then
			p = p + 1
		end
		return tok
	end

	local function peek(n)
		n = p + (n or 0)
		return tokens[n] or tokens[#tokens]
	end

	local function getTokenStartPosition(token)
		local line = 1
		local char = 0
		local tkNum = 1
		while true do
			local tk = tokens[tkNum]
			local tktext;
			if tk == token then
				tktext = tk.LeadingWhite
			else
				tktext = tk.LeadingWhite..tk.Source
			end
			for i = 1, #tktext do
				local c = tktext:sub(i, i)
				if c == '\n' then
					line = line + 1
					char = 0
				else
					char = char + 1
				end
			end
			if tk == token then
				break
			end
			tkNum = tkNum + 1
		end
		return line..":"..(char+1)
	end

	local function debugMark()
		local tk = peek()
		return "<"..tk.Type.." `"..tk.Source.."`> at: "..getTokenStartPosition(tk)
	end

	local function isBlockFollow()
		local tok = peek()
		return tok.Type == 'Eof' or (tok.Type == 'Keyword' and BlockFollowKeyword[tok.Source])
	end

	local function isUnop()
		return UnopSet[peek().Source] or false
	end

	local function isBinop()
		return BinopSet[peek().Source] or false
	end

	local function expect(type, source)
		local tk = peek()
		if tk.Type == type and (source == nil or tk.Source == source) then
			return get()
		else
			for i = -3, 3 do
				print("Tokens["..i.."] = `"..peek(i).Source.."`")
			end
			if source then
				error(getTokenStartPosition(tk)..": `"..source.."` expected.")
			else
				error(getTokenStartPosition(tk)..": "..type.." expected.")
			end
		end
	end

	local function MkNode(node) -- overloads and "virtualizes" the methods
		local methods = methodList[node.Type or node.CallType]
		node.VirtualGetFirstToken = methods.GetFirstToken
		node.VirtualGetLastToken = methods.GetLastToken
		node.GetFirstToken = methodList.node.GetFirstToken
		node.GetLastToken = methodList.node.GetLastToken
		return node
	end

	-- Forward decls
	local block;
	local expr;

	-- Expression list
	local function exprlist()
		local exprList = {}
		local commaList = {}
		table.insert(exprList, expr())
		while peek().Source == ',' do
			table.insert(commaList, get())
			table.insert(exprList, expr())
		end
		return exprList, commaList
	end

	local function prefixexpr()
		local tk = peek()
		if tk.Source == '(' then
			local oparenTk = get()
			local inner = expr()
			local cparenTk = expect('Symbol', ')')
			return MkNode{
				Type = 'ParenExpr';
				Expression = inner;
				Token_OpenParen = oparenTk;
				Token_CloseParen = cparenTk;
			}
		elseif tk.Type == 'Ident' then
			return MkNode{
				Type = 'VariableExpr';
				Token = get();
			}
		else
			print(debugMark())
			error(getTokenStartPosition(tk)..": Unexpected symbol")
		end
	end

	local function tableexpr()
		local obrace = expect('Symbol', '{')
		local entries = {}
		local separators = {}
		while peek().Source ~= '}' do
			if peek().Source == '[' then
				-- Index
				local obrac = get()
				local index = expr()
				local cbrac = expect('Symbol', ']')
				local eq = expect('Symbol', '=')
				local value = expr()
				table.insert(entries, {
					EntryType = 'Index';
					Index = index;
					Value = value;
					Token_OpenBracket = obrac;
					Token_CloseBracket = cbrac;
					Token_Equals = eq;
				})
			elseif peek().Type == 'Ident' and peek(1).Source == '=' then
				-- Field
				local field = get()
				local eq = get()
				local value = expr()
				table.insert(entries, {
					EntryType = 'Field';
					Field = field;
					Value = value;
					Token_Equals = eq;
				})
			else
				-- Value
				local value = expr()
				table.insert(entries, {
					EntryType = 'Value';
					Value = value;
				})
			end

			-- Comma or Semicolon separator
			if peek().Source == ',' or peek().Source == ';' then
				table.insert(separators, get())
			else
				break
			end
		end
		local cbrace = expect('Symbol', '}')
		return MkNode{
			Type = 'TableLiteral';
			EntryList = entries;
			Token_SeparatorList = separators;
			Token_OpenBrace = obrace;
			Token_CloseBrace = cbrace;
		}
	end

	-- List of identifiers
	local function varlist()
		local varList = {}
		local commaList = {}
		while peek().Source ~= ')' do
			local varg = peek().Source == '...' and get()
			local ident = varg or expect('Ident')

			if varg or ident then
				table.insert(varList, ident)
			end

			if not varg and peek().Source == ',' then
				table.insert(commaList, get())
			else
				break
			end
		end
		return varList, commaList
	end

	-- Body
	local function blockbody(terminator)
		local body = block()
		local after = peek()
		if after.Type == 'Keyword' and after.Source == terminator then
			get()
			return body, after
		else
			print(after.Type, after.Source)
			error(getTokenStartPosition(after)..": "..terminator.." expected.")
		end
	end

	-- Function declaration
	local function funcdecl(isAnonymous)
		local functionKw = get()
		--
		local nameChain;
		local nameChainSeparator;
		--
		if not isAnonymous then
			nameChain = {}
			nameChainSeparator = {}
			--
			table.insert(nameChain, expect('Ident'))
			--
			while peek().Source == '.' do
				table.insert(nameChainSeparator, get())
				table.insert(nameChain, expect('Ident'))
			end
			if peek().Source == ':' then
				table.insert(nameChainSeparator, get())
				table.insert(nameChain, expect('Ident'))
			end
		end
		--
		local oparenTk = expect('Symbol', '(')
		local argList, argCommaList = varlist()
		local cparenTk = expect('Symbol', ')')
		local fbody, enTk = blockbody('end')
		--
		return MkNode{
			Type = (isAnonymous and 'FunctionLiteral' or 'FunctionStat');
			NameChain = nameChain;
			ArgList = argList;
			Body = fbody;
			--
			Token_Function = functionKw;
			Token_NameChainSeparator = nameChainSeparator;
			Token_OpenParen = oparenTk;
			Token_ArgCommaList = argCommaList;
			Token_CloseParen = cparenTk;
			Token_End = enTk;
		}
	end

	-- Argument list passed to a funciton
	local function functionargs()
		local tk = peek()
		if tk.Source == '(' then
			local oparenTk = get()
			local argList = {}
			local argCommaList = {}
			while peek().Source ~= ')' do
				table.insert(argList, expr())
				if peek().Source == ',' then
					table.insert(argCommaList, get())
				else
					break
				end
			end
			local cparenTk = expect('Symbol', ')')
			return MkNode{
				CallType = 'ArgCall';
				ArgList = argList;
				--
				Token_CommaList = argCommaList;
				Token_OpenParen = oparenTk;
				Token_CloseParen = cparenTk;
			}
		elseif tk.Source == '{' then
			return MkNode{
				CallType = 'TableCall';
				TableExpr = expr();
			}
		elseif tk.Type == 'String' then
			return MkNode{
				CallType = 'StringCall';
				Token = get();
			}
		else
			error("Function arguments expected.")
		end
	end

	local function primarycall(base)
		return MkNode{
			Type = 'CallExpr';
			Base = base;
			FunctionArguments = functionargs();
		}
	end

	local function primaryexpr()
		local base = prefixexpr()
		assert(base, "nil prefixexpr")
		while true do
			local tk = peek()
			if tk.Source == '.' then
				local dotTk = get()
				local fieldName = expect('Ident')
				base = MkNode{
					Type = 'FieldExpr';
					Base = base;
					Field = fieldName;
					Token_Dot = dotTk;
				}
			elseif tk.Source == ':' then
				local colonTk = get()
				local methodName = expect('Ident')
				local fargs = functionargs()
				base = MkNode{
					Type = 'MethodExpr';
					Base = base;
					Method = methodName;
					FunctionArguments = fargs;
					Token_Colon = colonTk;
				}
			elseif tk.Source == '[' then
				local obrac = get()
				local index = expr()
				local cbrac = expect('Symbol', ']')
				base = MkNode{
					Type = 'IndexExpr';
					Base = base;
					Index = index;
					Token_OpenBracket = obrac;
					Token_CloseBracket = cbrac;
				}
			elseif tk.Source == '{' or tk.Source == '(' or tk.Type == 'String' then
				base = primarycall(base)
			else
				return base
			end
		end
	end

	local function simplenode(tt)
		return MkNode{
			Type = tt;
			Token = get();
		}
	end

	local function simpleexpr()
		local tk = peek()
		if tk.Type == 'Number' then
			return simplenode('NumberLiteral')
		elseif tk.Type == 'String' then
			return simplenode('StringLiteral')
		elseif tk.Source == 'nil' then
			return simplenode('NilLiteral')
		elseif tk.Source == 'true' or tk.Source == 'false' then
			return simplenode('BooleanLiteral')
		elseif tk.Source == '...' then
			return simplenode('VargLiteral')
		elseif tk.Source == '{' then
			return tableexpr()
		elseif tk.Source == 'function' then
			return funcdecl(true)
		else
			return primaryexpr()
		end
	end

	local function subexpr(limit)
		local curNode;

		-- Initial Base Expression
		if isUnop() then
			local opTk = get()
			local ex = subexpr(UnaryPriority)
			curNode = MkNode{
				Type = 'UnopExpr';
				Token_Op = opTk;
				Rhs = ex;
			}
		else
			curNode = simpleexpr()
			assert(curNode, "nil simpleexpr")
		end

		-- Apply Precedence Recursion Chain
		while isBinop() and BinaryPriority[peek().Source][1] > limit do
			local opTk = get()
			local rhs = subexpr(BinaryPriority[opTk.Source][2])
			assert(rhs, "RhsNeeded")
			curNode = MkNode{
				Type = 'BinopExpr';
				Lhs = curNode;
				Rhs = rhs;
				Token_Op = opTk;
			}
		end

		-- Return result
		return curNode
	end

	-- Expression
	expr = function()
		return subexpr(0)
	end

	-- Expression statement
	local function exprstat()
		local ex = primaryexpr()
		if ex.Type == 'MethodExpr' or ex.Type == 'CallExpr' then
			-- all good, calls can be statements
			return MkNode{
				Type = 'CallExprStat';
				Expression = ex;
			}
		else
			-- Assignment expr
			local lhs = {ex}
			local lhsSeparator = {}
			while peek().Source == ',' do
				table.insert(lhsSeparator, get())
				local lhsPart = primaryexpr()
				if lhsPart.Type == 'MethodExpr' or lhsPart.Type == 'CallExpr' then
					error("Bad left hand side of assignment")
				end
				table.insert(lhs, lhsPart)
			end
			local eq = expect('Symbol', '=')
			local rhs = {expr()}
			local rhsSeparator = {}
			while peek().Source == ',' do
				table.insert(rhsSeparator, get())
				table.insert(rhs, expr())
			end
			return MkNode{
				Type = 'AssignmentStat';
				Rhs = rhs;
				Lhs = lhs;
				Token_Equals = eq;
				Token_LhsSeparatorList = lhsSeparator;
				Token_RhsSeparatorList = rhsSeparator;
			}
		end
	end

	-- If statement
	local function ifstat()
		local ifKw = get()
		local condition = expr()
		local thenKw = expect('Keyword', 'then')
		local ifBody = block()
		local elseClauses = {}
		while peek().Source == 'elseif' or peek().Source == 'else' do
			local elseifKw = get()
			local elseifCondition, elseifThenKw;
			if elseifKw.Source == 'elseif' then
				elseifCondition = expr()
				elseifThenKw = expect('Keyword', 'then')
			end
			local elseifBody = block()
			table.insert(elseClauses, {
				Condition = elseifCondition;
				Body = elseifBody;
				--
				ClauseType = elseifKw.Source;
				Token = elseifKw;
				Token_Then = elseifThenKw;
			})
			if elseifKw.Source == 'else' then
				break
			end
		end
		local enKw = expect('Keyword', 'end')
		return MkNode{
			Type = 'IfStat';
			Condition = condition;
			Body = ifBody;
			ElseClauseList = elseClauses;
			--
			Token_If = ifKw;
			Token_Then = thenKw;
			Token_End = enKw;
		}
	end

	-- Do statement
	local function dostat()
		local doKw = get()
		local body, enKw = blockbody('end')
		--
		return MkNode{
			Type = 'DoStat';
			Body = body;
			--
			Token_Do = doKw;
			Token_End = enKw;
		}
	end

	-- While statement
	local function whilestat()
		local whileKw = get()
		local condition = expr()
		local doKw = expect('Keyword', 'do')
		local body, enKw = blockbody('end')
		--
		return MkNode{
			Type = 'WhileStat';
			Condition = condition;
			Body = body;
			--
			Token_While = whileKw;
			Token_Do = doKw;
			Token_End = enKw;
		}
	end

	-- For statement
	local function forstat()
		local forKw = get()
		local loopVars, loopVarCommas = varlist()
		-- local node = {} -- unused(?)
		if peek().Source == '=' then
			local eqTk = get()
			local exprList, exprCommaList = exprlist()
			if #exprList < 2 or #exprList > 3 then
				error("expected 2 or 3 values for range bounds")
			end
			local doTk = expect('Keyword', 'do')
			local body, enTk = blockbody('end')
			return MkNode{
				Type = 'NumericForStat';
				VarList = loopVars;
				RangeList = exprList;
				Body = body;
				--
				Token_For = forKw;
				Token_VarCommaList = loopVarCommas;
				Token_Equals = eqTk;
				Token_RangeCommaList = exprCommaList;
				Token_Do = doTk;
				Token_End = enTk;
			}
		elseif peek().Source == 'in' then
			local inTk = get()
			local exprList, exprCommaList = exprlist()
			local doTk = expect('Keyword', 'do')
			local body, enTk = blockbody('end')
			return MkNode{
				Type = 'GenericForStat';
				VarList = loopVars;
				GeneratorList = exprList;
				Body = body;
				--
				Token_For = forKw;
				Token_VarCommaList = loopVarCommas;
				Token_In = inTk;
				Token_GeneratorCommaList = exprCommaList;
				Token_Do = doTk;
				Token_End = enTk;
			}
		else
			error("`=` or in expected")
		end
	end

	-- Repeat statement
	local function repeatstat()
		local repeatKw = get()
		local body, untilTk = blockbody('until')
		local condition = expr()
		return MkNode{
			Type = 'RepeatStat';
			Body = body;
			Condition = condition;
			--
			Token_Repeat = repeatKw;
			Token_Until = untilTk;
		}
	end

	-- Local var declaration
	local function localdecl()
		local localKw = get()
		if peek().Source == 'function' then
			-- Local function def
			local funcStat = funcdecl(false)
			if #funcStat.NameChain > 1 then
				error(getTokenStartPosition(funcStat.Token_NameChainSeparator[1])..": `(` expected.")
			end
			return MkNode{
				Type = 'LocalFunctionStat';
				FunctionStat = funcStat;
				Token_Local = localKw;
			}
		elseif peek().Type == 'Ident' then
			-- Local variable declaration
			local varList, varCommaList = varlist()
			local exprList, exprCommaList = {}, {}
			local eqToken;
			if peek().Source == '=' then
				eqToken = get()
				exprList, exprCommaList = exprlist()
			end
			return MkNode{
				Type = 'LocalVarStat';
				VarList = varList;
				ExprList = exprList;
				Token_Local = localKw;
				Token_Equals = eqToken;
				Token_VarCommaList = varCommaList;
				Token_ExprCommaList = exprCommaList;
			}
		else
			error("`function` or ident expected")
		end
	end

	-- Return statement
	local function retstat()
		local returnKw = get()
		local exprList;
		local commaList;
		if isBlockFollow() or peek().Source == ';' then
			exprList = {}
			commaList = {}
		else
			exprList, commaList = exprlist()
		end
		return {
			Type = 'ReturnStat';
			ExprList = exprList;
			Token_Return = returnKw;
			Token_CommaList = commaList;
			GetFirstToken = methodList.ReturnStat.GetFirstToken;
			GetLastToken = methodList.ReturnStat.GetLastToken;
		}
	end

	-- Break statement
	local function breakstat()
		local breakKw = get()
		return {
			Type = 'BreakStat';
			Token_Break = breakKw;
			GetFirstToken = methodList.BreakStat.GetFirstToken;
			GetLastToken = methodList.BreakStat.GetLastToken;
		}
	end

	-- Expression
	local function statement()
		local tok = peek()
		if tok.Source == 'if' then
			return false, ifstat()
		elseif tok.Source == 'while' then
			return false, whilestat()
		elseif tok.Source == 'do' then
			return false, dostat()
		elseif tok.Source == 'for' then
			return false, forstat()
		elseif tok.Source == 'repeat' then
			return false, repeatstat()
		elseif tok.Source == 'function' then
			return false, funcdecl(false)
		elseif tok.Source == 'local' then
			return false, localdecl()
		elseif tok.Source == 'return' then
			return true, retstat()
		elseif tok.Source == 'break' then
			return true, breakstat()
		else
			return false, exprstat()
		end
	end

	-- Chunk
	block = function()
		local statements = {}
		local semicolons = {}
		local isLast = false
		while not isLast and not isBlockFollow() do
			-- Parse statement
			local stat;
			isLast, stat = statement()
			table.insert(statements, stat)
			local next = peek()
			if next.Type == 'Symbol' and next.Source == ';' then
				semicolons[#statements] = get()
			end
		end
		return {
			Type = 'StatList';
			StatementList = statements;
			SemicolonList = semicolons;
			GetFirstToken = methodList.StatList.GetFirstToken;
			GetLastToken = methodList.StatList.GetLastToken;
		}
	end

	return block()
end

local function VisitAst(ast, visitors)
	local ExprType = lookupify{
		'BinopExpr'; 'UnopExpr';
		'NumberLiteral'; 'StringLiteral'; 'NilLiteral'; 'BooleanLiteral'; 'VargLiteral';
		'FieldExpr'; 'IndexExpr';
		'MethodExpr'; 'CallExpr';
		'FunctionLiteral';
		'VariableExpr';
		'ParenExpr';
		'TableLiteral';
	}

	local StatType = lookupify{
		'StatList';
		'BreakStat';
		'ReturnStat';
		'LocalVarStat';
		'LocalFunctionStat';
		'FunctionStat';
		'RepeatStat';
		'GenericForStat';
		'NumericForStat';
		'WhileStat';
		'DoStat';
		'IfStat';
		'CallExprStat';
		'AssignmentStat';
	}

	-- Check for typos in visitor construction
	for visitorSubject, _ in pairs(visitors) do
		if not StatType[visitorSubject] and not ExprType[visitorSubject] then
			error("Invalid visitor target: `"..visitorSubject.."`")
		end
	end

	-- Helpers to call visitors on a node
	local function preVisit(exprOrStat)
		local visitor = visitors[exprOrStat.Type]
		if type(visitor) == 'function' then
			return visitor(exprOrStat)
		elseif visitor and visitor.Pre then
			return visitor.Pre(exprOrStat)
		end
	end
	local function postVisit(exprOrStat)
		local visitor = visitors[exprOrStat.Type]
		if visitor and type(visitor) == 'table' and visitor.Post then
			return visitor.Post(exprOrStat)
		end
	end

	local visitExpr, visitStat;

	visitExpr = function(expr)
		if preVisit(expr) then
			-- Handler did custom child iteration or blocked child iteration
			return
		end
		if expr.Type == 'BinopExpr' then
			visitExpr(expr.Lhs)
			visitExpr(expr.Rhs)
		elseif expr.Type == 'UnopExpr' then
			visitExpr(expr.Rhs)
		elseif expr.Type == 'FieldExpr' then
			visitExpr(expr.Base)
		elseif expr.Type == 'IndexExpr' then
			visitExpr(expr.Base)
			visitExpr(expr.Index)
		elseif expr.Type == 'MethodExpr' or expr.Type == 'CallExpr' then
			visitExpr(expr.Base)
			if expr.FunctionArguments.CallType == 'ArgCall' then
				for _, argExpr in pairs(expr.FunctionArguments.ArgList) do
					visitExpr(argExpr)
				end
			elseif expr.FunctionArguments.CallType == 'TableCall' then
				visitExpr(expr.FunctionArguments.TableExpr)
			end
		elseif expr.Type == 'FunctionLiteral' then
			visitStat(expr.Body)
		elseif expr.Type == 'ParenExpr' then
			visitExpr(expr.Expression)
		elseif expr.Type == 'TableLiteral' then
			for _, entry in pairs(expr.EntryList) do
				if entry.EntryType == 'Field' then
					visitExpr(entry.Value)
				elseif entry.EntryType == 'Index' then
					visitExpr(entry.Index)
					visitExpr(entry.Value)
				elseif entry.EntryType == 'Value' then
					visitExpr(entry.Value)
				else
					assert(false, "unreachable")
				end
			end
		else
			local eType = expr.Type
			local ok = eType == 'NumberLiteral' or eType == 'StringLiteral' or
				eType == 'NilLiteral' or eType == 'BooleanLiteral' or
				eType == 'VargLiteral' or eType == 'VariableExpr' -- single node or no children

			if not ok then
				assert(false, "unreachable, type: "..eType..":"..FormatTable(expr))
			end
		end
		postVisit(expr)
	end

	visitStat = function(stat)
		if preVisit(stat) then
			-- Handler did custom child iteration or blocked child iteration
			return
		end
		if stat.Type == 'StatList' then
			for _, ch in pairs(stat.StatementList) do
				visitStat(ch)
			end
		elseif stat.Type == 'ReturnStat' then
			for _, expr in pairs(stat.ExprList) do
				visitExpr(expr)
			end
		elseif stat.Type == 'LocalVarStat' then
			if stat.Token_Equals then
				for _, expr in pairs(stat.ExprList) do
					visitExpr(expr)
				end
			end
		elseif stat.Type == 'LocalFunctionStat' then
			visitStat(stat.FunctionStat.Body)
		elseif stat.Type == 'FunctionStat' then
			visitStat(stat.Body)
		elseif stat.Type == 'RepeatStat' then
			visitStat(stat.Body)
			visitExpr(stat.Condition)
		elseif stat.Type == 'GenericForStat' then
			for _, expr in pairs(stat.GeneratorList) do
				visitExpr(expr)
			end
			visitStat(stat.Body)
		elseif stat.Type == 'NumericForStat' then
			for _, expr in pairs(stat.RangeList) do
				visitExpr(expr)
			end
			visitStat(stat.Body)
		elseif stat.Type == 'WhileStat' then
			visitExpr(stat.Condition)
			visitStat(stat.Body)
		elseif stat.Type == 'DoStat' then
			visitStat(stat.Body)
		elseif stat.Type == 'IfStat' then
			visitExpr(stat.Condition)
			visitStat(stat.Body)
			for _, clause in pairs(stat.ElseClauseList) do
				if clause.Condition then
					visitExpr(clause.Condition)
				end
				visitStat(clause.Body)
			end
		elseif stat.Type == 'CallExprStat' then
			visitExpr(stat.Expression)
		elseif stat.Type == 'AssignmentStat' then
			for _, ex in pairs(stat.Lhs) do
				visitExpr(ex)
			end
			for _, ex in pairs(stat.Rhs) do
				visitExpr(ex)
			end
		else
			local ok = stat.Type == 'BreakStat'

			if not ok then
				assert(false, "unreachable")
			end
		end
		postVisit(stat)
	end

	if StatType[ast.Type] then
		visitStat(ast)
	else
		visitExpr(ast)
	end
end

local function AddVariableInfo(ast)
	local globalVars = {}
	local currentScope = nil

	-- Numbering generator for variable lifetimes
	local locationGenerator = 0
	local function markLocation()
		locationGenerator = locationGenerator + 1
		return locationGenerator
	end

	local function ScopeGetVar(self, varName)
		for _, var in pairs(self.VariableList) do
			if var.Name == varName then
				return var
			end
		end
		if self.ParentScope then
			return self.ParentScope:GetVar(varName)
		else
			for _, var in pairs(globalVars) do
				if var.Name == varName then
					return var
				end
			end
		end
	end

	-- Scope management
	local function pushScope()
		currentScope = {
			ParentScope = currentScope;
			ChildScopeList = {};
			VariableList = {};
			BeginLocation = markLocation();
		}
		if currentScope.ParentScope then
			currentScope.Depth = currentScope.ParentScope.Depth + 1
			table.insert(currentScope.ParentScope.ChildScopeList, currentScope)
		else
			currentScope.Depth = 1
		end

		currentScope.GetVar = ScopeGetVar
	end

	local function popScope()
		local scope = currentScope

		-- Mark where this scope ends
		scope.EndLocation = markLocation()

		-- Mark all of the variables in the scope as ending there
		for _, var in pairs(scope.VariableList) do
			var.ScopeEndLocation = scope.EndLocation
		end

		-- Move to the parent scope
		currentScope = scope.ParentScope

		return scope
	end
	pushScope() -- push initial scope

	-- Add / reference variables
	local function addLocalVar(name, setNameFunc, localInfo)
		assert(localInfo, "Missing localInfo")
		assert(name, "Missing local var name")
		local var = {
			Type = 'Local';
			Name = name;
			RenameList = {setNameFunc};
			AssignedTo = false;
			Info = localInfo;
			UseCount = 0;
			Scope = currentScope;
			BeginLocation = markLocation();
			EndLocation = markLocation();
			ReferenceLocationList = {markLocation()};
		}

		var.Rename = methodList.Scoping.Rename
		var.Reference = methodList.Scoping.Reference
		table.insert(currentScope.VariableList, var)
		return var
	end

	local function getGlobalVar(name)
		for _, var in pairs(globalVars) do
			if var.Name == name then
				return var
			end
		end
		local var = {
			Type = 'Global';
			Name = name;
			RenameList = {};
			AssignedTo = false;
			UseCount = 0;
			Scope = nil; -- Globals have no scope
			BeginLocation = markLocation();
			EndLocation = markLocation();
			ReferenceLocationList = {};
		}

		var.Rename = methodList.Scoping.Rename
		var.Reference = methodList.Scoping.Reference
		table.insert(globalVars, var)
		return var
	end

	local function addGlobalReference(name, setNameFunc)
		assert(name, "Missing var name")
		local var = getGlobalVar(name)
		table.insert(var.RenameList, setNameFunc)
		return var
	end

	local function getLocalVar(scope, name)
		-- First search this scope
		-- Note: Reverse iterate here because Lua does allow shadowing a local
		--       within the same scope, and the later defined variable should
		--       be the one referenced.
		for i = #scope.VariableList, 1, -1 do
			if scope.VariableList[i].Name == name then
				return scope.VariableList[i]
			end
		end

		-- Then search parent scope
		if scope.ParentScope then
			local var = getLocalVar(scope.ParentScope, name)
			if var then
				return var
			end
		end

		-- Then
		return nil
	end

	local function referenceVariable(name, setNameFunc)
		assert(name, "Missing var name")
		local var = getLocalVar(currentScope, name)
		if var then
			table.insert(var.RenameList, setNameFunc)
		else
			var = addGlobalReference(name, setNameFunc)
		end
		-- Update the end location of where this variable is used, and
		-- add this location to the list of references to this variable.
		local curLocation = markLocation()
		var.EndLocation = curLocation
		table.insert(var.ReferenceLocationList, var.EndLocation)
		return var
	end

	local function renameFuncParams(params)
		for index, ident in pairs(params) do
			if ident.Source ~= '...' then
				addLocalVar(ident.Source, function(name)
					ident.Source = name
				end, {
					Type = 'Argument';
					Index = index;
				})
			end
		end
	end

	local visitor = {}
	visitor.FunctionLiteral = {
		-- Function literal adds a new scope and adds the function literal arguments
		-- as local variables in the scope.
		Pre = function(expr)
			pushScope()
			renameFuncParams(expr.ArgList)
		end;
		Post = function(_) -- expr
			popScope()
		end;
	}
	visitor.VariableExpr = function(expr)
		-- Variable expression references from existing local varibales
		-- in the current scope, annotating the variable usage with variable
		-- information.
		expr.Variable = referenceVariable(expr.Token.Source, function(newName)
			expr.Token.Source = newName
		end)
	end
	visitor.StatList = {
		-- StatList adds a new scope
		Pre = function(_) -- stat
			pushScope()
		end;
		Post = function(_) -- stat
			popScope()
		end;
	}
	visitor.LocalVarStat = {
		Post = function(stat)
			-- Local var stat adds the local variables to the current scope as locals
			-- We need to visit the subexpressions first, because these new locals
			-- will not be in scope for the initialization value expressions. That is:
			--  `local bar = bar + 1`
			-- Is valid code
			for varNum, ident in pairs(stat.VarList) do
				addLocalVar(ident.Source, function(name)
					stat.VarList[varNum].Source = name
				end, {
					Type = 'Local';
				})
			end
		end;
	}
	visitor.LocalFunctionStat = {
		Pre = function(stat)
			-- Local function stat adds the function itself to the current scope as
			-- a local variable, and creates a new scope with the function arguments
			-- as local variables.
			addLocalVar(stat.FunctionStat.NameChain[1].Source, function(name)
				stat.FunctionStat.NameChain[1].Source = name
			end, {
				Type = 'LocalFunction';
			})
			pushScope()
			renameFuncParams(stat.FunctionStat.ArgList)
		end;
		Post = function()
			popScope()
		end;
	}
	visitor.FunctionStat = {
		Pre = function(stat)
			-- Function stat adds a new scope containing the function arguments
			-- as local variables.
			-- A function stat may also assign to a global variable if it is in
			-- the form `function foo()` with no additional dots/colons in the
			-- name chain.
			local nameChain = stat.NameChain -- variable could be a local already
			local var = referenceVariable(nameChain[1].Source, function(name)
				nameChain[1].Source = name
			end)

			var.AssignedTo = true

			pushScope()
			renameFuncParams(stat.ArgList)
		end;
		Post = function()
			popScope()
		end;
	}
	visitor.RepeatStat = {
		Pre = function(stat)
			-- Repeat statements needs a custom scope for its condition
			-- Avoid calling the visitor for StatList because it
			-- creates a new scope that leaves out the condition
			pushScope()
			for _, ch in pairs(stat.Body.StatementList) do
				VisitAst(ch, visitor)
			end
			VisitAst(stat.Condition, visitor)
			popScope()
			return true
		end
	}
	visitor.GenericForStat = {
		Pre = function(stat)
			-- Generic fors need an extra scope holding the range variables
			-- Need a custom visitor so that the generator expressions can be
			-- visited before we push a scope, but the body can be visited
			-- after we push a scope.
			for _, ex in pairs(stat.GeneratorList) do
				VisitAst(ex, visitor)
			end
			pushScope()
			for index, ident in pairs(stat.VarList) do
				addLocalVar(ident.Source, function(name)
					ident.Source = name
				end, {
					Type = 'ForRange';
					Index = index;
				})
			end
			VisitAst(stat.Body, visitor)
			popScope()
			return true -- Custom visit
		end;
	}
	visitor.NumericForStat = {
		Pre = function(stat)
			-- Numeric fors need an extra scope holding the range variables
			-- Need a custom visitor so that the generator expressions can be
			-- visited before we push a scope, but the body can be visited
			-- after we push a scope.
			for _, ex in pairs(stat.RangeList) do
				VisitAst(ex, visitor)
			end
			pushScope()
			for index, ident in pairs(stat.VarList) do
				addLocalVar(ident.Source, function(name)
					ident.Source = name
				end, {
					Type = 'ForRange';
					Index = index;
				})
			end
			VisitAst(stat.Body, visitor)
			popScope()
			return true	-- Custom visit
		end;
	}
	visitor.AssignmentStat = {
		Post = function(stat)
			-- For an assignment statement we need to mark the
			-- "assigned to" flag on variables.
			for _, ex in pairs(stat.Lhs) do
				if ex.Variable then
					ex.Variable.AssignedTo = true
				end
			end
		end;
	}

	VisitAst(ast, visitor)

	return globalVars, popScope()
end

-- Prints out an AST to a string
local function PrintAst(ast)
	local printStat, printExpr;

	local function printt(tk)
		if not tk.LeadingWhite or not tk.Source then
			error("Bad token: "..FormatTable(tk))
		end
		io.write(tk.LeadingWhite)
		io.write(tk.Source)
	end

	printExpr = function(expr)
		if expr.Type == 'BinopExpr' then
			printExpr(expr.Lhs)
			printt(expr.Token_Op)
			printExpr(expr.Rhs)
		elseif expr.Type == 'UnopExpr' then
			printt(expr.Token_Op)
			printExpr(expr.Rhs)
		elseif expr.Type == 'NumberLiteral' or expr.Type == 'StringLiteral' or
			expr.Type == 'NilLiteral' or expr.Type == 'BooleanLiteral' or
			expr.Type == 'VargLiteral'
		then
			-- Just print the token
			printt(expr.Token)
		elseif expr.Type == 'FieldExpr' then
			printExpr(expr.Base)
			printt(expr.Token_Dot)
			printt(expr.Field)
		elseif expr.Type == 'IndexExpr' then
			printExpr(expr.Base)
			printt(expr.Token_OpenBracket)
			printExpr(expr.Index)
			printt(expr.Token_CloseBracket)
		elseif expr.Type == 'MethodExpr' or expr.Type == 'CallExpr' then
			printExpr(expr.Base)
			if expr.Type == 'MethodExpr' then
				printt(expr.Token_Colon)
				printt(expr.Method)
			end
			if expr.FunctionArguments.CallType == 'StringCall' then
				printt(expr.FunctionArguments.Token)
			elseif expr.FunctionArguments.CallType == 'ArgCall' then
				printt(expr.FunctionArguments.Token_OpenParen)
				for index, argExpr in pairs(expr.FunctionArguments.ArgList) do
					printExpr(argExpr)
					local sep = expr.FunctionArguments.Token_CommaList[index]
					if sep then
						printt(sep)
					end
				end
				printt(expr.FunctionArguments.Token_CloseParen)
			elseif expr.FunctionArguments.CallType == 'TableCall' then
				printExpr(expr.FunctionArguments.TableExpr)
			end
		elseif expr.Type == 'FunctionLiteral' then
			printt(expr.Token_Function)
			printt(expr.Token_OpenParen)
			for index, arg in pairs(expr.ArgList) do
				printt(arg)
				local comma = expr.Token_ArgCommaList[index]
				if comma then
					printt(comma)
				end
			end
			printt(expr.Token_CloseParen)
			printStat(expr.Body)
			printt(expr.Token_End)
		elseif expr.Type == 'VariableExpr' then
			printt(expr.Token)
		elseif expr.Type == 'ParenExpr' then
			printt(expr.Token_OpenParen)
			printExpr(expr.Expression)
			printt(expr.Token_CloseParen)
		elseif expr.Type == 'TableLiteral' then
			printt(expr.Token_OpenBrace)
			for index, entry in pairs(expr.EntryList) do
				if entry.EntryType == 'Field' then
					printt(entry.Field)
					printt(entry.Token_Equals)
					printExpr(entry.Value)
				elseif entry.EntryType == 'Index' then
					printt(entry.Token_OpenBracket)
					printExpr(entry.Index)
					printt(entry.Token_CloseBracket)
					printt(entry.Token_Equals)
					printExpr(entry.Value)
				elseif entry.EntryType == 'Value' then
					printExpr(entry.Value)
				else
					assert(false, "unreachable")
				end
				local sep = expr.Token_SeparatorList[index]
				if sep then
					printt(sep)
				end
			end
			printt(expr.Token_CloseBrace)
		else
			assert(false, "unreachable, type: "..expr.Type..":"..FormatTable(expr))
		end
	end

	printStat = function(stat)
		if stat.Type == 'StatList' then
			for index, ch in pairs(stat.StatementList) do
				printStat(ch)
				if stat.SemicolonList[index] then
					printt(stat.SemicolonList[index])
				end
			end
		elseif stat.Type == 'BreakStat' then
			printt(stat.Token_Break)
		elseif stat.Type == 'ReturnStat' then
			printt(stat.Token_Return)
			for index, expr in pairs(stat.ExprList) do
				printExpr(expr)
				if stat.Token_CommaList[index] then
					printt(stat.Token_CommaList[index])
				end
			end
		elseif stat.Type == 'LocalVarStat' then
			printt(stat.Token_Local)
			for index, var in pairs(stat.VarList) do
				printt(var)
				local comma = stat.Token_VarCommaList[index]
				if comma then
					printt(comma)
				end
			end
			if stat.Token_Equals then
				printt(stat.Token_Equals)
				for index, expr in pairs(stat.ExprList) do
					printExpr(expr)
					local comma = stat.Token_ExprCommaList[index]
					if comma then
						printt(comma)
					end
				end
			end
		elseif stat.Type == 'LocalFunctionStat' then
			printt(stat.Token_Local)
			printt(stat.FunctionStat.Token_Function)
			printt(stat.FunctionStat.NameChain[1])
			printt(stat.FunctionStat.Token_OpenParen)
			for index, arg in pairs(stat.FunctionStat.ArgList) do
				printt(arg)
				local comma = stat.FunctionStat.Token_ArgCommaList[index]
				if comma then
					printt(comma)
				end
			end
			printt(stat.FunctionStat.Token_CloseParen)
			printStat(stat.FunctionStat.Body)
			printt(stat.FunctionStat.Token_End)
		elseif stat.Type == 'FunctionStat' then
			printt(stat.Token_Function)
			for index, part in pairs(stat.NameChain) do
				printt(part)
				local sep = stat.Token_NameChainSeparator[index]
				if sep then
					printt(sep)
				end
			end
			printt(stat.Token_OpenParen)
			for index, arg in pairs(stat.ArgList) do
				printt(arg)
				local comma = stat.Token_ArgCommaList[index]
				if comma then
					printt(comma)
				end
			end
			printt(stat.Token_CloseParen)
			printStat(stat.Body)
			printt(stat.Token_End)
		elseif stat.Type == 'RepeatStat' then
			printt(stat.Token_Repeat)
			printStat(stat.Body)
			printt(stat.Token_Until)
			printExpr(stat.Condition)
		elseif stat.Type == 'GenericForStat' then
			printt(stat.Token_For)
			for index, var in pairs(stat.VarList) do
				printt(var)
				local sep = stat.Token_VarCommaList[index]
				if sep then
					printt(sep)
				end
			end
			printt(stat.Token_In)
			for index, expr in pairs(stat.GeneratorList) do
				printExpr(expr)
				local sep = stat.Token_GeneratorCommaList[index]
				if sep then
					printt(sep)
				end
			end
			printt(stat.Token_Do)
			printStat(stat.Body)
			printt(stat.Token_End)
		elseif stat.Type == 'NumericForStat' then
			printt(stat.Token_For)
			for index, var in pairs(stat.VarList) do
				printt(var)
				local sep = stat.Token_VarCommaList[index]
				if sep then
					printt(sep)
				end
			end
			printt(stat.Token_Equals)
			for index, expr in pairs(stat.RangeList) do
				printExpr(expr)
				local sep = stat.Token_RangeCommaList[index]
				if sep then
					printt(sep)
				end
			end
			printt(stat.Token_Do)
			printStat(stat.Body)
			printt(stat.Token_End)
		elseif stat.Type == 'WhileStat' then
			printt(stat.Token_While)
			printExpr(stat.Condition)
			printt(stat.Token_Do)
			printStat(stat.Body)
			printt(stat.Token_End)
		elseif stat.Type == 'DoStat' then
			printt(stat.Token_Do)
			printStat(stat.Body)
			printt(stat.Token_End)
		elseif stat.Type == 'IfStat' then
			printt(stat.Token_If)
			printExpr(stat.Condition)
			printt(stat.Token_Then)
			printStat(stat.Body)
			for _, clause in pairs(stat.ElseClauseList) do
				printt(clause.Token)
				if clause.Condition then
					printExpr(clause.Condition)
					printt(clause.Token_Then)
				end
				printStat(clause.Body)
			end
			printt(stat.Token_End)
		elseif stat.Type == 'CallExprStat' then
			printExpr(stat.Expression)
		elseif stat.Type == 'AssignmentStat' then
			for index, ex in pairs(stat.Lhs) do
				printExpr(ex)
				local sep = stat.Token_LhsSeparatorList[index]
				if sep then
					printt(sep)
				end
			end
			printt(stat.Token_Equals)
			for index, ex in pairs(stat.Rhs) do
				printExpr(ex)
				local sep = stat.Token_RhsSeparatorList[index]
				if sep then
					printt(sep)
				end
			end
		else
			assert(false, "unreachable")
		end
	end

	printStat(ast)
end

-- Adds / removes whitespace in an AST to put it into a "standard formatting"
local function FormatAst(ast)
	local formatStat, formatExpr;

	local currentIndent = 0

	local function applyIndent(token)
		local indentString = '\n'..('\t'):rep(currentIndent)
		if token.LeadingWhite == '' or (token.LeadingWhite:sub(-#indentString, -1) ~= indentString) then
			-- Trim existing trailing whitespace on LeadingWhite
			-- Trim trailing tabs and spaces, and up to one newline
			token.LeadingWhite = token.LeadingWhite:gsub("\n?[\t ]*$", "")
			token.LeadingWhite = token.LeadingWhite..indentString
		end
	end

	local function indent()
		currentIndent = currentIndent + 1
	end

	local function undent()
		currentIndent = currentIndent - 1
		assert(currentIndent >= 0, "Undented too far")
	end

	local function leadingChar(tk)
		if #tk.LeadingWhite > 0 then
			return tk.LeadingWhite:sub(1,1)
		else
			return tk.Source:sub(1,1)
		end
	end

	local function padToken(tk)
		if not WhiteChars[leadingChar(tk)] then
			tk.LeadingWhite = ' '..tk.LeadingWhite
		end
	end

	local function padExpr(expr)
		padToken(expr:GetFirstToken())
	end

	local function formatBody(_, bodyStat, closeToken) -- openToken
		indent()
		formatStat(bodyStat)
		undent()
		applyIndent(closeToken)
	end

	formatExpr = function(expr)
		if expr.Type == 'BinopExpr' then
			formatExpr(expr.Lhs)
			formatExpr(expr.Rhs)
			if expr.Token_Op.Source ~= '..' then
				-- No padding on ..
				padExpr(expr.Rhs)
				padToken(expr.Token_Op)
			end
		elseif expr.Type == 'UnopExpr' then
			formatExpr(expr.Rhs)
			--(expr.Token_Op)
		elseif expr.Type == 'FieldExpr' then
			formatExpr(expr.Base)
			--(expr.Token_Dot)
			--(expr.Field)
		elseif expr.Type == 'IndexExpr' then
			formatExpr(expr.Base)
			formatExpr(expr.Index)
			--(expr.Token_OpenBracket)
			--(expr.Token_CloseBracket)
		elseif expr.Type == 'MethodExpr' or expr.Type == 'CallExpr' then
			formatExpr(expr.Base)
			--[[if expr.Type == 'MethodExpr' then
				--(expr.Token_Colon)
				--(expr.Method)
			end]]
			--[[if expr.FunctionArguments.CallType == 'StringCall' then
				--(expr.FunctionArguments.Token)
			else]]
			if expr.FunctionArguments.CallType == 'ArgCall' then
				--(expr.FunctionArguments.Token_OpenParen)
				for index, argExpr in pairs(expr.FunctionArguments.ArgList) do
					formatExpr(argExpr)
					if index > 1 then
						padExpr(argExpr)
					end
					--[[local sep = expr.FunctionArguments.Token_CommaList[index]
					if sep then
						--(sep)
					end]]
				end
				--(expr.FunctionArguments.Token_CloseParen)
			elseif expr.FunctionArguments.CallType == 'TableCall' then
				formatExpr(expr.FunctionArguments.TableExpr)
			end
		elseif expr.Type == 'FunctionLiteral' then
			--(expr.Token_Function)
			--(expr.Token_OpenParen)
			for index, arg in pairs(expr.ArgList) do
				--(arg)
				if index > 1 then
					padToken(arg)
				end
				--[[local comma = expr.Token_ArgCommaList[index]
				if comma then
					--(comma)
				end]]
			end
			--(expr.Token_CloseParen)
			formatBody(expr.Token_CloseParen, expr.Body, expr.Token_End)
		elseif expr.Type == 'ParenExpr' then
			formatExpr(expr.Expression)
			--(expr.Token_OpenParen)
			--(expr.Token_CloseParen)
		elseif expr.Type == 'TableLiteral' then
			--(expr.Token_OpenBrace)
			if #expr.EntryList ~= 0 then
				indent()
				for _, entry in pairs(expr.EntryList) do
					if entry.EntryType == 'Field' then
						applyIndent(entry.Field)
						padToken(entry.Token_Equals)
						formatExpr(entry.Value)
						padExpr(entry.Value)
					elseif entry.EntryType == 'Index' then
						applyIndent(entry.Token_OpenBracket)
						formatExpr(entry.Index)
						--(entry.Token_CloseBracket)
						padToken(entry.Token_Equals)
						formatExpr(entry.Value)
						padExpr(entry.Value)
					elseif entry.EntryType == 'Value' then
						formatExpr(entry.Value)
						applyIndent(entry.Value:GetFirstToken())
					else
						assert(false, "unreachable")
					end
					--[[local sep = expr.Token_SeparatorList[index]
					if sep then
						--(sep)
					end]]
				end
				undent()
				applyIndent(expr.Token_CloseBrace)
			end
			--(expr.Token_CloseBrace)
		else
			local eType = expr.Type
			local ok = eType == 'NumberLiteral' or eType == 'StringLiteral' or
				eType == 'NilLiteral' or eType == 'BooleanLiteral' or
				eType == 'VargLiteral' or eType == 'VariableExpr'

			if not ok then
				assert(false, "unreachable, type: "..eType..":"..FormatTable(expr))
			end
		end
	end

	formatStat = function(stat)
		if stat.Type == 'StatList' then
			for _, substat in pairs(stat.StatementList) do
				formatStat(substat)
				applyIndent(substat:GetFirstToken())
			end
		elseif stat.Type == 'ReturnStat' then
			--(stat.Token_Return)
			for _, expr in pairs(stat.ExprList) do
				formatExpr(expr)
				padExpr(expr)
				--[[if stat.Token_CommaList[index] then
					--(stat.Token_CommaList[index])
				end]]
			end
		elseif stat.Type == 'LocalVarStat' then
			--(stat.Token_Local)
			for _, var in pairs(stat.VarList) do
				padToken(var)
				--[[local comma = stat.Token_VarCommaList[index]
				if comma then
					--(comma)
				end]]
			end
			if stat.Token_Equals then
				padToken(stat.Token_Equals)
				for _, expr in pairs(stat.ExprList) do
					formatExpr(expr)
					padExpr(expr)
					--[[local comma = stat.Token_ExprCommaList[index]
					if comma then
						--(comma)
					end]]
				end
			end
		elseif stat.Type == 'LocalFunctionStat' then
			--(stat.Token_Local)
			padToken(stat.FunctionStat.Token_Function)
			padToken(stat.FunctionStat.NameChain[1])
			--(stat.FunctionStat.Token_OpenParen)
			for index, arg in pairs(stat.FunctionStat.ArgList) do
				if index > 1 then
					padToken(arg)
				end
				--[[local comma = stat.FunctionStat.Token_ArgCommaList[index]
				if comma then
					--(comma)
				end]]
			end
			--(stat.FunctionStat.Token_CloseParen)
			formatBody(stat.FunctionStat.Token_CloseParen, stat.FunctionStat.Body, stat.FunctionStat.Token_End)
		elseif stat.Type == 'FunctionStat' then
			--(stat.Token_Function)
			for index, part in pairs(stat.NameChain) do
				if index == 1 then
					padToken(part)
				end
				--[[local sep = stat.Token_NameChainSeparator[index]
				if sep then
					--(sep)
				end]]
			end
			--(stat.Token_OpenParen)
			for index, arg in pairs(stat.ArgList) do
				if index > 1 then
					padToken(arg)
				end
				--[[local comma = stat.Token_ArgCommaList[index]
				if comma then
					--(comma)
				end]]
			end
			--(stat.Token_CloseParen)
			formatBody(stat.Token_CloseParen, stat.Body, stat.Token_End)
		elseif stat.Type == 'RepeatStat' then
			--(stat.Token_Repeat)
			formatBody(stat.Token_Repeat, stat.Body, stat.Token_Until)
			formatExpr(stat.Condition)
			padExpr(stat.Condition)
		elseif stat.Type == 'GenericForStat' then
			--(stat.Token_For)
			for _, var in pairs(stat.VarList) do
				padToken(var)
				--[[local sep = stat.Token_VarCommaList[index]
				if sep then
					--(sep)
				end]]
			end
			padToken(stat.Token_In)
			for _, expr in pairs(stat.GeneratorList) do
				formatExpr(expr)
				padExpr(expr)
				--[[local sep = stat.Token_GeneratorCommaList[index]
				if sep then
					--(sep)
				end]]
			end
			padToken(stat.Token_Do)
			formatBody(stat.Token_Do, stat.Body, stat.Token_End)
		elseif stat.Type == 'NumericForStat' then
			--(stat.Token_For)
			for _, var in pairs(stat.VarList) do
				padToken(var)
				--[[local sep = stat.Token_VarCommaList[index]
				if sep then
					--(sep)
				end]]
			end
			padToken(stat.Token_Equals)
			for _, expr in pairs(stat.RangeList) do
				formatExpr(expr)
				padExpr(expr)
				--[[local sep = stat.Token_RangeCommaList[index]
				if sep then
					--(sep)
				end]]
			end
			padToken(stat.Token_Do)
			formatBody(stat.Token_Do, stat.Body, stat.Token_End)
		elseif stat.Type == 'WhileStat' then
			--(stat.Token_While)
			formatExpr(stat.Condition)
			padExpr(stat.Condition)
			padToken(stat.Token_Do)
			formatBody(stat.Token_Do, stat.Body, stat.Token_End)
		elseif stat.Type == 'DoStat' then
			--(stat.Token_Do)
			formatBody(stat.Token_Do, stat.Body, stat.Token_End)
		elseif stat.Type == 'IfStat' then
			--(stat.Token_If)
			formatExpr(stat.Condition)
			padExpr(stat.Condition)
			padToken(stat.Token_Then)
			--
			local lastBodyOpen = stat.Token_Then
			local lastBody = stat.Body
			--
			for _, clause in pairs(stat.ElseClauseList) do
				formatBody(lastBodyOpen, lastBody, clause.Token)
				lastBodyOpen = clause.Token
				--
				if clause.Condition then
					formatExpr(clause.Condition)
					padExpr(clause.Condition)
					padToken(clause.Token_Then)
					lastBodyOpen = clause.Token_Then
				end
				lastBody = clause.Body
			end
			--
			formatBody(lastBodyOpen, lastBody, stat.Token_End)

		elseif stat.Type == 'CallExprStat' then
			formatExpr(stat.Expression)
		elseif stat.Type == 'AssignmentStat' then
			for index, ex in pairs(stat.Lhs) do
				formatExpr(ex)
				if index > 1 then
					padExpr(ex)
				end
				--[[local sep = stat.Token_LhsSeparatorList[index]
				if sep then
					--(sep)
				end]]
			end
			padToken(stat.Token_Equals)
			for _, ex in pairs(stat.Rhs) do
				formatExpr(ex)
				padExpr(ex)
				--[[local sep = stat.Token_RhsSeparatorList[index]
				if sep then
					--(sep)
				end]]
			end
		else
			local ok = stat.Type == 'BreakStat'

			assert(ok, "unreachable")
		end
	end

	formatStat(ast)
end

-- Strips as much whitespace off of tokens in an AST as possible without causing problems
local function StripAst(ast)
	local stripStat, stripExpr;

	local function stript(token)
		token.LeadingWhite = ''
	end

	-- Make to adjacent tokens as close as possible
	local function joint(tokenA, tokenB)
		-- Strip the second token's whitespace
		stript(tokenB)

		-- Get the trailing A <-> leading B character pair
		local lastCh = tokenA.Source:sub(-1, -1)
		local firstCh = tokenB.Source:sub(1, 1)

		-- Cases to consider:
		--  Touching minus signs -> comment: `- -42` -> `--42' is invalid
		--  Touching words: `a b` -> `ab` is invalid
		--  Touching digits: `2 3`, can't occurr in the Lua syntax as number literals aren't a primary expression
		--  Abiguous syntax: `f(x)\n(x)()` is already disallowed, we can't cause a problem by removing newlines

		-- Figure out what separation is needed
		if
			(lastCh == '-' and firstCh == '-') or
			(AllIdentChars[lastCh] and AllIdentChars[firstCh])
		then
			tokenB.LeadingWhite = ' ' -- Use a separator
		else
			tokenB.LeadingWhite = '' -- Don't use a separator
		end
	end

	-- Join up a statement body and it's opening / closing tokens
	local function bodyjoint(open, body, close)
		stripStat(body)
		stript(close)
		local bodyFirst = body:GetFirstToken()
		local bodyLast = body:GetLastToken()
		if bodyFirst then
			-- Body is non-empty, join body to open / close
			joint(open, bodyFirst)
			joint(bodyLast, close)
		else
			-- Body is empty, just join open and close token together
			joint(open, close)
		end
	end

	stripExpr = function(expr)
		if expr.Type == 'BinopExpr' then
			stripExpr(expr.Lhs)
			stript(expr.Token_Op)
			stripExpr(expr.Rhs)
			-- Handle the `a - -b` -/-> `a--b` case which would otherwise incorrectly generate a comment
			-- Also handles operators "or" / "and" which definitely need joining logic in a bunch of cases
			joint(expr.Token_Op, expr.Rhs:GetFirstToken())
			joint(expr.Lhs:GetLastToken(), expr.Token_Op)
		elseif expr.Type == 'UnopExpr' then
			stript(expr.Token_Op)
			stripExpr(expr.Rhs)
			-- Handle the `- -b` -/-> `--b` case which would otherwise incorrectly generate a comment
			joint(expr.Token_Op, expr.Rhs:GetFirstToken())
		elseif expr.Type == 'NumberLiteral' or expr.Type == 'StringLiteral' or
			expr.Type == 'NilLiteral' or expr.Type == 'BooleanLiteral' or
			expr.Type == 'VargLiteral'
		then
			-- Just print the token
			stript(expr.Token)
		elseif expr.Type == 'FieldExpr' then
			stripExpr(expr.Base)
			stript(expr.Token_Dot)
			stript(expr.Field)
		elseif expr.Type == 'IndexExpr' then
			stripExpr(expr.Base)
			stript(expr.Token_OpenBracket)
			stripExpr(expr.Index)
			stript(expr.Token_CloseBracket)
		elseif expr.Type == 'MethodExpr' or expr.Type == 'CallExpr' then
			stripExpr(expr.Base)
			if expr.Type == 'MethodExpr' then
				stript(expr.Token_Colon)
				stript(expr.Method)
			end
			if expr.FunctionArguments.CallType == 'StringCall' then
				stript(expr.FunctionArguments.Token)
			elseif expr.FunctionArguments.CallType == 'ArgCall' then
				stript(expr.FunctionArguments.Token_OpenParen)
				for index, argExpr in pairs(expr.FunctionArguments.ArgList) do
					stripExpr(argExpr)
					local sep = expr.FunctionArguments.Token_CommaList[index]
					if sep then
						stript(sep)
					end
				end
				stript(expr.FunctionArguments.Token_CloseParen)
			elseif expr.FunctionArguments.CallType == 'TableCall' then
				stripExpr(expr.FunctionArguments.TableExpr)
			end
		elseif expr.Type == 'FunctionLiteral' then
			stript(expr.Token_Function)
			stript(expr.Token_OpenParen)
			for index, arg in pairs(expr.ArgList) do
				stript(arg)
				local comma = expr.Token_ArgCommaList[index]
				if comma then
					stript(comma)
				end
			end
			stript(expr.Token_CloseParen)
			bodyjoint(expr.Token_CloseParen, expr.Body, expr.Token_End)
		elseif expr.Type == 'VariableExpr' then
			stript(expr.Token)
		elseif expr.Type == 'ParenExpr' then
			stript(expr.Token_OpenParen)
			stripExpr(expr.Expression)
			stript(expr.Token_CloseParen)
		elseif expr.Type == 'TableLiteral' then
			stript(expr.Token_OpenBrace)
			for index, entry in pairs(expr.EntryList) do
				if entry.EntryType == 'Field' then
					stript(entry.Field)
					stript(entry.Token_Equals)
					stripExpr(entry.Value)
				elseif entry.EntryType == 'Index' then
					stript(entry.Token_OpenBracket)
					stripExpr(entry.Index)
					stript(entry.Token_CloseBracket)
					stript(entry.Token_Equals)
					stripExpr(entry.Value)
				elseif entry.EntryType == 'Value' then
					stripExpr(entry.Value)
				else
					assert(false, "unreachable")
				end
				local sep = expr.Token_SeparatorList[index]
				if sep then
					stript(sep)
				end
			end
			stript(expr.Token_CloseBrace)
		else
			assert(false, "unreachable, type: "..expr.Type..":"..FormatTable(expr))
		end
	end

	stripStat = function(stat)
		if stat.Type == 'StatList' then
			-- Strip all surrounding whitespace on statement lists along with separating whitespace
			for i = 1, #stat.StatementList do
				local chStat = stat.StatementList[i]

				-- Strip the statement and it's whitespace
				stripStat(chStat)
				stript(chStat:GetFirstToken())

				-- If there was a last statement, join them appropriately
				local lastChStat = stat.StatementList[i-1]
				if lastChStat then
					-- See if we can remove a semi-colon, the only case where we can't is if
					-- this and the last statement have a `);(` pair, where removing the semi-colon
					-- would introduce ambiguous syntax.
					if stat.SemicolonList[i-1] and
						(lastChStat:GetLastToken().Source ~= ')' or chStat:GetFirstToken().Source ~= ')')
					then
						stat.SemicolonList[i-1] = nil
					end

					-- If there isn't a semi-colon, we should safely join the two statements
					-- (If there is one, then no whitespace leading chStat is always okay)
					if not stat.SemicolonList[i-1] then
						joint(lastChStat:GetLastToken(), chStat:GetFirstToken())
					end
				end
			end

			-- A semi-colon is never needed on the last stat in a statlist:
			stat.SemicolonList[#stat.StatementList] = nil

			-- The leading whitespace on the statlist should be stripped
			if #stat.StatementList > 0 then
				stript(stat.StatementList[1]:GetFirstToken())
			end

		elseif stat.Type == 'BreakStat' then
			stript(stat.Token_Break)

		elseif stat.Type == 'ReturnStat' then
			stript(stat.Token_Return)
			for index, expr in pairs(stat.ExprList) do
				stripExpr(expr)
				if stat.Token_CommaList[index] then
					stript(stat.Token_CommaList[index])
				end
			end
			if #stat.ExprList > 0 then
				joint(stat.Token_Return, stat.ExprList[1]:GetFirstToken())
			end
		elseif stat.Type == 'LocalVarStat' then
			stript(stat.Token_Local)
			for index, var in pairs(stat.VarList) do
				if index == 1 then
					joint(stat.Token_Local, var)
				else
					stript(var)
				end
				local comma = stat.Token_VarCommaList[index]
				if comma then
					stript(comma)
				end
			end
			if stat.Token_Equals then
				stript(stat.Token_Equals)
				for index, expr in pairs(stat.ExprList) do
					stripExpr(expr)
					local comma = stat.Token_ExprCommaList[index]
					if comma then
						stript(comma)
					end
				end
			end
		elseif stat.Type == 'LocalFunctionStat' then
			stript(stat.Token_Local)
			joint(stat.Token_Local, stat.FunctionStat.Token_Function)
			joint(stat.FunctionStat.Token_Function, stat.FunctionStat.NameChain[1])
			joint(stat.FunctionStat.NameChain[1], stat.FunctionStat.Token_OpenParen)
			for index, arg in pairs(stat.FunctionStat.ArgList) do
				stript(arg)
				local comma = stat.FunctionStat.Token_ArgCommaList[index]
				if comma then
					stript(comma)
				end
			end
			stript(stat.FunctionStat.Token_CloseParen)
			bodyjoint(stat.FunctionStat.Token_CloseParen, stat.FunctionStat.Body, stat.FunctionStat.Token_End)
		elseif stat.Type == 'FunctionStat' then
			stript(stat.Token_Function)
			for index, part in pairs(stat.NameChain) do
				if index == 1 then
					joint(stat.Token_Function, part)
				else
					stript(part)
				end
				local sep = stat.Token_NameChainSeparator[index]
				if sep then
					stript(sep)
				end
			end
			stript(stat.Token_OpenParen)
			for index, arg in pairs(stat.ArgList) do
				stript(arg)
				local comma = stat.Token_ArgCommaList[index]
				if comma then
					stript(comma)
				end
			end
			stript(stat.Token_CloseParen)
			bodyjoint(stat.Token_CloseParen, stat.Body, stat.Token_End)
		elseif stat.Type == 'RepeatStat' then
			stript(stat.Token_Repeat)
			bodyjoint(stat.Token_Repeat, stat.Body, stat.Token_Until)
			stripExpr(stat.Condition)
			joint(stat.Token_Until, stat.Condition:GetFirstToken())
		elseif stat.Type == 'GenericForStat' then
			stript(stat.Token_For)
			for index, var in pairs(stat.VarList) do
				if index == 1 then
					joint(stat.Token_For, var)
				else
					stript(var)
				end
				local sep = stat.Token_VarCommaList[index]
				if sep then
					stript(sep)
				end
			end
			joint(stat.VarList[#stat.VarList], stat.Token_In)
			for index, expr in pairs(stat.GeneratorList) do
				stripExpr(expr)
				if index == 1 then
					joint(stat.Token_In, expr:GetFirstToken())
				end
				local sep = stat.Token_GeneratorCommaList[index]
				if sep then
					stript(sep)
				end
			end
			joint(stat.GeneratorList[#stat.GeneratorList]:GetLastToken(), stat.Token_Do)
			bodyjoint(stat.Token_Do, stat.Body, stat.Token_End)
		elseif stat.Type == 'NumericForStat' then
			stript(stat.Token_For)
			for index, var in pairs(stat.VarList) do
				if index == 1 then
					joint(stat.Token_For, var)
				else
					stript(var)
				end
				local sep = stat.Token_VarCommaList[index]
				if sep then
					stript(sep)
				end
			end
			joint(stat.VarList[#stat.VarList], stat.Token_Equals)
			for index, expr in pairs(stat.RangeList) do
				stripExpr(expr)
				if index == 1 then
					joint(stat.Token_Equals, expr:GetFirstToken())
				end
				local sep = stat.Token_RangeCommaList[index]
				if sep then
					stript(sep)
				end
			end
			joint(stat.RangeList[#stat.RangeList]:GetLastToken(), stat.Token_Do)
			bodyjoint(stat.Token_Do, stat.Body, stat.Token_End)
		elseif stat.Type == 'WhileStat' then
			stript(stat.Token_While)
			stripExpr(stat.Condition)
			stript(stat.Token_Do)
			joint(stat.Token_While, stat.Condition:GetFirstToken())
			joint(stat.Condition:GetLastToken(), stat.Token_Do)
			bodyjoint(stat.Token_Do, stat.Body, stat.Token_End)
		elseif stat.Type == 'DoStat' then
			stript(stat.Token_Do)
			stript(stat.Token_End)
			bodyjoint(stat.Token_Do, stat.Body, stat.Token_End)
		elseif stat.Type == 'IfStat' then
			stript(stat.Token_If)
			stripExpr(stat.Condition)
			joint(stat.Token_If, stat.Condition:GetFirstToken())
			joint(stat.Condition:GetLastToken(), stat.Token_Then)
			--
			local lastBodyOpen = stat.Token_Then
			local lastBody = stat.Body
			--
			for _, clause in pairs(stat.ElseClauseList) do
				bodyjoint(lastBodyOpen, lastBody, clause.Token)
				lastBodyOpen = clause.Token
				--
				if clause.Condition then
					stripExpr(clause.Condition)
					joint(clause.Token, clause.Condition:GetFirstToken())
					joint(clause.Condition:GetLastToken(), clause.Token_Then)
					lastBodyOpen = clause.Token_Then
				end
				stripStat(clause.Body)
				lastBody = clause.Body
			end
			--
			bodyjoint(lastBodyOpen, lastBody, stat.Token_End)

		elseif stat.Type == 'CallExprStat' then
			stripExpr(stat.Expression)
		elseif stat.Type == 'AssignmentStat' then
			for index, ex in pairs(stat.Lhs) do
				stripExpr(ex)
				local sep = stat.Token_LhsSeparatorList[index]
				if sep then
					stript(sep)
				end
			end
			stript(stat.Token_Equals)
			for index, ex in pairs(stat.Rhs) do
				stripExpr(ex)
				local sep = stat.Token_RhsSeparatorList[index]
				if sep then
					stript(sep)
				end
			end
		else
			assert(false, "unreachable")
		end
	end

	stripStat(ast)
end

local function FoldConstants(ast)
	local foldStat, foldExpr
	local arithFolds, unopFolds
	local countList

	local function isReal(n)
		return (n == n) and tonumber(tostring(n)) or nil
	end

	local function isNumeric(what)
		return what.Type == 'Number'
			or (what.Type == 'String' and tonumber(what.Source))
	end

	local function isInvalidList(list)
		return list.Type == 'TableLiteral' and not countList(list)
	end

	local function isNotLiteral(tt)
		return not string.find(tt, 'Literal', 1, true)
	end

	local function getParenValue(expr)
		if expr.Type == 'ParenExpr' then
			return getParenValue(expr.Expression)
		else
			return expr
		end
	end

	local function replaceExpr(expr, name, tt, value)
		local methods = methodList[name]
		local leading = expr:GetFirstToken().LeadingWhite

		for i in pairs(expr) do
			expr[i] = nil
		end

		expr.Type = name
		expr.Token = {
			Type = tt,
			Source = tostring(value),
			LeadingWhite = leading
		}

		expr.GetFirstToken = methods.GetFirstToken
		expr.GetLastToken = methods.GetLastToken
	end

	function countList(expr)
		local value
		local ok = true
		local last = 1
		local list = {}

		for _, entry in pairs(expr.EntryList) do
			local idx

			if isNotLiteral(entry.Value.Type) or isInvalidList(entry.Value) then
				ok = false
				break
			end

			if entry.EntryType == 'Index' then
				local idxt = entry.Index.Type

				if idxt == 'NumberLiteral' then
					local flt = tonumber(entry.Index.Token.Source)

					if flt % 1 == 0 then
						idx = flt
					end
				elseif isNotLiteral(idxt) or isInvalidList(entry.Value) or idxt == 'NilLiteral' or idxt == 'VargLiteral' then
					ok = false
					break
				end
			elseif entry.EntryType == 'Value' then
				idx = last
				last = last + 1
			elseif entry.EntryType == 'Field' then
				idx = nil
			else
				assert(false, "unreachable")
			end

			if idx then
				list[idx] = entry.Value.Type
			end
		end

		if ok then
			local size = #list

			if size > 0 then
				if list[size] == 'VargLiteral' then
					ok = false
				elseif list[size] == 'NilLiteral' then
					for i = 1, size do
						if list[i] == 'NilLiteral' then -- as per Lua manual
							size = i - 1
							break
						end
					end
				end
			end

			if ok then
				value = size
			end
		end

		return value
	end

	arithFolds = {
		['+'] = function(left, right)
			return left.Source + right.Source
		end;
		['-'] = function(left, right)
			return left.Source - right.Source
		end;
		['*'] = function(left, right)
			return left.Source * right.Source
		end;
		['/'] = function(left, right)
			return isReal(left.Source / right.Source)
		end;
		['%'] = function(left, right)
			return isReal(left.Source % right.Source)
		end;
		['^'] = function(left, right)
			return isReal(left.Source ^ right.Source)
		end;
	}

	unopFolds = {
		['-'] = function(right)
			local name, value

			if isNumeric(right) then
				name = 'NumberLiteral'
				value = -right.Source
			end

			return name, 'Number', value
		end;
		['not'] = function(right)
			local name = 'BooleanLiteral'
			local value

			if right.Type == 'Number' then
				value = false
			elseif right.Type == 'String' then
				value = false
			elseif right.Type == 'Nil' then
				value = true
			elseif right.Type == 'Keyword' then
				value = right.Source == 'true'
			else
				name = nil
			end

			return name, 'Keyword', value
		end;
		['#'] = function(right)
			local name, value

			if right.Type == 'String' then -- don't need to call `string.char`, a `.` will do, we preverify
				local escaped = right.Source:gsub('\\%d%d?%d?', '.'):gsub('\\.', '.')
				local pad

				if right.Source:sub(1, 1) ~= '[' then
					pad = 1
				else
					local _, finish = string.find(right.Source, '^%[=-%[')
					pad = finish
				end

				value = #escaped - pad * 2
				name = 'NumberLiteral'
			end

			return name, 'Number', value
		end
	}

	function foldExpr(expr)
		if expr.Type == 'BinopExpr' then
			local Op = expr.Token_Op.Source
			local Lhs = getParenValue(expr.Lhs)
			local Rhs = getParenValue(expr.Rhs)
			local name, tt, value

			foldExpr(Lhs)
			foldExpr(Rhs)

			if arithFolds[Op] and Lhs.Token and Rhs.Token then
				if isNumeric(Lhs.Token) and isNumeric(Rhs.Token) then
					value = arithFolds[Op](Lhs.Token, Rhs.Token)

					if value then
						name = 'NumberLiteral'
						tt = 'Number'
					end
				end
			end

			if name then
				replaceExpr(expr, name, tt, value)
			end
		elseif expr.Type == 'UnopExpr' then
			local Rhs = getParenValue(expr.Rhs)

			foldExpr(Rhs)

			if Rhs.Token then
				local handler = assert(unopFolds[expr.Token_Op.Source],
					'no proper unary handler for `' .. expr.Token_Op.Source .. '`')

				local name, tt, value = handler(Rhs.Token)

				if name then
					replaceExpr(expr, name, tt, value)
				end
			elseif expr.Token_Op.Source == '#' and Rhs.Type == 'TableLiteral' then
				local value = countList(Rhs)

				if value then
					replaceExpr(expr, 'NumberLiteral', 'Number', value)
				end
			end
		elseif expr.Type == 'NumberLiteral' or expr.Type == 'StringLiteral' or
			expr.Type == 'NilLiteral' or expr.Type == 'BooleanLiteral' or
			expr.Type == 'VargLiteral'
		then
			-- Do not interact
			return
		elseif expr.Type == 'FieldExpr' then
			foldExpr(expr.Base)
		elseif expr.Type == 'IndexExpr' then
			foldExpr(expr.Base)
			foldExpr(expr.Index)
		elseif expr.Type == 'MethodExpr' or expr.Type == 'CallExpr' then
			foldExpr(expr.Base)
			--if expr.FunctionArguments.CallType == 'StringCall' then
			--else
			if expr.FunctionArguments.CallType == 'ArgCall' then
				for i = 1, #expr.FunctionArguments.ArgList do
					foldExpr(expr.FunctionArguments.ArgList[i])
				end
			elseif expr.FunctionArguments.CallType == 'TableCall' then
				foldExpr(expr.FunctionArguments.TableExpr)
			end
		elseif expr.Type == 'FunctionLiteral' then
			foldStat(expr.Body)
		elseif expr.Type == 'VariableExpr' then -- nothing?
			return
		elseif expr.Type == 'ParenExpr' then
			foldExpr(expr.Expression)

			if expr.Expression.Type == 'ParenExpr' then
				local exp = expr.Expression

				for i in pairs(expr) do
					expr[i] = nil
				end

				for i, v in pairs(exp) do
					expr[i] = v
				end
			end
		elseif expr.Type == 'TableLiteral' then
			for _, entry in pairs(expr.EntryList) do
				if entry.EntryType == 'Field' then
					foldExpr(entry.Value)
				elseif entry.EntryType == 'Index' then
					foldExpr(entry.Index)
					foldExpr(entry.Value)
				elseif entry.EntryType == 'Value' then
					foldExpr(entry.Value)
				else
					assert(false, "unreachable")
				end
			end
		else
			assert(false, "unreachable, type: "..expr.Type..":"..FormatTable(expr))
		end
	end

	function foldStat(stat)
		if stat.Type == 'StatList' then
			for i = 1, #stat.StatementList do
				foldStat(stat.StatementList[i])
			end
		elseif stat.Type == 'BreakStat' then
			return -- nothing
		elseif stat.Type == 'ReturnStat' then
			for i = 1, #stat.ExprList do
				foldExpr(stat.ExprList[i])
			end
		elseif stat.Type == 'LocalVarStat' then
			if stat.Token_Equals then
				for i = 1, #stat.ExprList do
					foldExpr(stat.ExprList[i])
				end
			end
		elseif stat.Type == 'LocalFunctionStat' then
			foldStat(stat.FunctionStat.Body)
		elseif stat.Type == 'FunctionStat' then
			foldStat(stat.Body)
		elseif stat.Type == 'RepeatStat' then
			foldStat(stat.Body)
			foldExpr(stat.Condition)
		elseif stat.Type == 'GenericForStat' then
			for i = 1, #stat.GeneratorList do
				foldExpr(stat.GeneratorList[i])
			end
			foldStat(stat.Body)
		elseif stat.Type == 'NumericForStat' then
			--for i = 1, #stat.VarList do
			--	foldStat(stat.VarList[i])
			--end
			for i = 1, #stat.RangeList do
				foldExpr(stat.RangeList[i])
			end
			foldStat(stat.Body)
		elseif stat.Type == 'WhileStat' then
			foldExpr(stat.Condition)
			foldStat(stat.Body)
		elseif stat.Type == 'DoStat' then
			foldStat(stat.Body)
		elseif stat.Type == 'IfStat' then
			foldExpr(stat.Condition)
			foldStat(stat.Body)

			for _, clause in pairs(stat.ElseClauseList) do
				if clause.Condition then
					foldExpr(clause.Condition)
				end

				foldStat(clause.Body)
			end
		elseif stat.Type == 'CallExprStat' then
			foldExpr(stat.Expression)
		elseif stat.Type == 'AssignmentStat' then
			for i = 1, #stat.Lhs do
				foldExpr(stat.Lhs[i])
			end
			for i = 1, #stat.Rhs do
				foldExpr(stat.Rhs[i])
			end
		else
			assert(false, "unreachable")
		end
	end

	foldStat(ast)
end

return {
	CreateLuaParser = CreateLuaParser,
	AddVariableInfo = AddVariableInfo,
	FoldConstants = FoldConstants,
	StripAst = StripAst,
	FormatAst = FormatAst,
	PrintAst = PrintAst
}

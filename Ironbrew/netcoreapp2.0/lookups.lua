local data = {}

-- Helper functions for dealing with the data
local function lookupify(tb)
	for _, v in pairs(tb) do
		tb[v] = true
	end

	return tb
end

local function range(s, e)
	local t = {}
	s = string.byte(s)
	e = string.byte(e)

	for i = s, e do
		table.insert(t, string.char(i))
	end

	return t
end

local function merge(...)
	local args = {...}
	local t = {}

	for _, sub in ipairs(args) do
		for _, l in ipairs(sub) do
			table.insert(t, l)
		end
	end

	return t
end

-- Define the data tables
data.WhiteChars = lookupify {' ', '\n', '\t', '\r'}

--[[
data.CharacterForEscape =
	setmetatable(
	{},
	{
		__index = function(self, what)
			self[what] = what
			return what
		end,
		__metatable = 'Escapes'
	}
)
--[==[
--]]
data.CharacterForEscape = {
	['"'] = '"',
	['\\'] = '\\',
	['a'] = '\a',
	['b'] = '\b',
	['f'] = '\f',
	['n'] = '\n',
	['r'] = '\r',
	['t'] = '\t',
	['v'] = '\v',
	['z'] = '\z',
	["'"] = "'"
}
--]==]

data.AllIdentChars = lookupify(merge(range('a', 'z'), range('A', 'Z'), range('0', '9'), {'_'}))

data.AllIdentStartChars = lookupify(merge(range('a', 'z'), range('A', 'Z'), {'_'}))

data.Digits = lookupify(range('0', '9'))

data.EqualSymbols = lookupify {'~', '=', '>', '<'}

data.HexDigits = lookupify(merge(range('a', 'f'), range('A', 'F'), range('0', '9')))

data.Symbols = lookupify {'+', '-', '*', '/', '^', '%', ',', '{', '}', '[', ']', '(', ')', ';', '#', '.', ':'}

data.Keywords =
	lookupify {
	'and',
	'break',
	'do',
	'else',
	'elseif',
	'end',
	'false',
	'for',
	'function',
	'goto',
	'if',
	'in',
	'local',
	'nil',
	'not',
	'or',
	'repeat',
	'return',
	'then',
	'true',
	'until',
	'while'
}

data.BlockFollowKeyword = lookupify {'else', 'elseif', 'until', 'end'}

data.UnopSet = lookupify {'-', 'not', '#'}

data.BinopSet =
	lookupify {
	'+',
	'-',
	'*',
	'/',
	'%',
	'^',
	'#',
	'..',
	'.',
	':',
	'>',
	'<',
	'<=',
	'>=',
	'~=',
	'==',
	'and',
	'or'
}

data.GlobalRenameIgnore = {}

data.BinaryPriority = {
	['+'] = {6, 6},
	['-'] = {6, 6},
	['*'] = {7, 7},
	['/'] = {7, 7},
	['%'] = {7, 7},
	['^'] = {10, 9},
	['..'] = {5, 4},
	['=='] = {3, 3},
	['~='] = {3, 3},
	['>'] = {3, 3},
	['<'] = {3, 3},
	['>='] = {3, 3},
	['<='] = {3, 3},
	['and'] = {2, 2},
	['or'] = {1, 1}
}

data.UnaryPriority = 8

data.lookupify = lookupify

data.range = range

data.merge = merge

return data

local InFile = io.open('luac.out', 'rb')

local Script = InFile:read'*a'

InFile:close()

os.remove('luac.out')
os.remove('Out1.lua')

local RerFile = io.open('Rerubi.min.lua', 'rb')

local Rerubi = RerFile:read'*a'

RerFile:close()

Script = Script:gsub(".", function(bb) return "\\" .. bb:byte() end) or Script .. "\""

Script = Rerubi .. ' aL("'..Script..'")()'

local OutFile = io.open('Out.lua', 'w+')

OutFile:write('--[[ \n  Obfuscated with Narfuscator \n]] \n' .. Script)

OutFile:close()

print('Finished')
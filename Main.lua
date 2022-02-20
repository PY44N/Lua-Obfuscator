local InFile = io.open('luac.out', 'rb')

local Script = InFile:read'*a'

InFile:close()

os.remove('luac.out')
os.remove('Out1.lua')

local RerFile = io.open('Rerubi.min.lua', 'rb')

local Rerubi = RerFile:read'*a'

RerFile:close()

local bytes = {}

Script:gsub(".", function(bb) table.insert(bytes, string.byte(bb)) end)

Script = table.concat(bytes, ",")

Script = Rerubi .. '({'..Script..'})()'

local OutFile = io.open('Out.lua', 'w+')

OutFile:write(Script)

OutFile:close()

print('Finished')
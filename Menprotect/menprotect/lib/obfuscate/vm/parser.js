const print = console.log

const functions = require('../../funcs')
const funcs = new functions()

const structure_mapping_strings = {
    info: `local Args, Upvals = gBit(), gBit()`,
    instructions: `
for i1 = 1, gType() do -- Amount of instructions
    Instructions[i1] = {} -- Register
    for i2 = 1, gBit() - 2 do -- For each value in register (except Enum and Value, hence -2)
        Instructions[i1][i2] = gType() -- Add to register
    end

    Instructions[i1].O_VALUE = gType() -- Add Value
    Instructions[i1].O_ENUM = gType() -- Add Enum
end`,
    constants: `
for i = 1, gType() do -- Amount of constants
    Constants[i] = gType()
end`,
    protos: `
for i = 1, gType() do -- Amount of protos
    Protos[i] = decode_chunk()
end`,
}

module.exports = function(data) {
    let mapping = data[0]
    let keys = data[1]

    let structureMapping = mapping.structure
    let typeMapping = mapping.type

    return `
    local function parse(bytecode)
        bytecode = encrypt((bytecode), ${keys.byte})
        
        local type_index, bit_idx
        type_index = {
            [${typeMapping[1]}] = _tostring,
            [${typeMapping[2]}] = _tonumber,
            [${typeMapping[3]}] = function(bit)
                bit_idx = {
                    not _true,
                    _true,
                }
                return bit_idx[bit + 1]
            end,
        }

        local Pos = 1
        local function Next(x)
            Pos = Pos + (x or 1)
        end

        local function silent_gBit()
            local Bit = Byte(bytecode, Pos, Pos)
            return Bit
        end

        local function gBit()
            local Bit = silent_gBit()
            Next()
            return Bit
        end

        local function gBits(n)
            n = n or 1
            local Bits = {}
            for i = 1, n do
                Bits[i] = gBit()
            end
            return _tonumber(Concat(Bits))
        end

        local function gString(n)
            local Bits = {}
            for i = 1, n do
                Bits[i] = Char(gBit())
            end
            return Concat(Bits)
        end

        local gType
        function gType()
            local Type = gBit()
            if Type == 0 then return end

            local Length = 1
            local lFunc = Type == ${typeMapping[1]} and gType or gBit

            if Type ~= ${typeMapping[3]} then -- If not boolean
                Length = lFunc()
            end

            local isNegative = false
            if ((Type == ${typeMapping[2]} or Type == ${typeMapping[4]}) and silent_gBit() == 0) and (Length ~= 1) then
                isNegative = _true
            end

            if Type == ${typeMapping[4]} then -- decimal number
                local number = gBits(Length)
                local _decimal = gBits(gBit())
                local decimal = _decimal / (10 ^ #_tostring(_decimal))
                local fNumber = number + decimal

                return isNegative and -fNumber or fNumber
            else
                local Func = (Type == ${typeMapping[3]} and gBit) or (Type == ${typeMapping[2]} and gBits) or gString
                local Data = type_index[Type](Func(Length))
                return isNegative and -Data or Data
            end
        end

        gString(0xB)
        local vmkey = gBit()

        local function decode_chunk()
            local Instructions = {}
            local Constants = {}
            local Protos = {}

            ${structure_mapping_strings[structureMapping[0]]}
            ${structure_mapping_strings[structureMapping[1]]}
            ${structure_mapping_strings[structureMapping[2]]}
            ${structure_mapping_strings[structureMapping[3]]}

            return {
                O_INSTR = Instructions,
                O_CONST = Constants,
                O_PROTO = Protos,
                O_ARGS = Args,
                O_UPVALS = Upvals,
            }
        end

        local function gPayload(isNumber)
            local _func = isNumber and _tonumber or empty_func
            local queue = {}
            for i = 1, gBit() do
                queue[i] = _func(encrypt(gType(), vmkey))
            end
            return queue
        end

        vm_strings = gPayload()

        return decode_chunk()
    end

    `
}

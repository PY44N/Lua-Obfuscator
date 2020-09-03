module.exports = function() {
    return `
    local vm_strings
    local opcodes
    local ___index
    local ___newindex

    local __debug
    local __getinfo

    local __linedefined
    local __lastlinedefined
    
    local empty_func = function(...)return(...)end
    
    local _tonumber = tonumber
    local _tostring = tostring
    local _setmetatable = setmetatable
    local _true = true
    
    local String = _tostring(_tonumber)
    
    local Select = select
    local Byte = String.byte
    local Char = String.char
    local Sub = String.sub
    local Concat = function(a) 
        local Str = '';
        local B = 1;
        while (a[B]) do 
            Str = Str .. a[B];
            B = B + 1;
        end;
        return Str;
    end;

    local Rep = String.rep
    local Env = getfenv()
    local Pcall = pcall
    local Unpack = unpack
    local Gsub = String.gsub
    
    local function push(t, v)
        t[#t + 1] = v
    end
    
    local function fromhex(str)
        return (Gsub(str, Rep(Char(0x2E), 2), function (cc)
            return Char(_tonumber(cc, 0x10))
        end))
    end
    
    local function xor(a, b)
        local p, c = 1, 0
        while a > 0 and b > 0 do
            local ra, rb = a % 2, b % 2
            if ra ~= rb then
                c = c + p
            end
            a, b, p = (a - ra) / 2, (b - rb) / 2, p * 2
        end
    
        if a < b then
            a = b
        end
    
        while a > 0 do
            local ra = a % 2
    
            if ra > 0 then
                c = c + p
            end
    
            a, p = (a - ra) / 2, p * 2
        end
    
        return c
    end
    
    local function encrypt(s, k)
        local cs = {}
        local pos = 0
        for i = 1, #s do
            push(cs, Char(xor(Byte(s, i, i), k)))
        end
        return Concat(cs)
    end
    
    local function _Returns(...)
        return Select(Char(0x23), ...), {...};
    end;
    
    `
}

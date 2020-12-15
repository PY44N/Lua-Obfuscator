

local function MP_PROTECT(...) return(...) end


local function MP_CRASH(...) while true do end end


local function MP_JUNK(...) return(...) end


    local __MP_RUNTIME_ID = 
((function()
local function xor(a,b)
    local p,c=1,0
    while a>0 and b>0 do
        local ra,rb=a%2,b%2
        if ra~=rb then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    if a<b then a=b end
    while a>0 do
        local ra=a%2
        if ra>0 then c=c+p end
        a,p=(a-ra)/2,p*2
    end
    return c
end

local X = tostring({})
local ID = X:sub(10, #X)

local cs = ''
for i = 1, #ID do
    cs = cs .. xor(string.byte(ID:sub(i, i)), 84)
end

return cs:sub(2, 9)
end)())

    
local function MP_ID(...) 
        return __MP_RUNTIME_ID
     end


local function MP_RANDOM(...) return(...) end
print("Hi")
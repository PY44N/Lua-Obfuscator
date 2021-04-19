
local Byte         = string.byte;
local Char         = string.char;
local Sub          = string.sub;
local Concat       = table.concat;
local LDExp        = math.ldexp;
local GetFEnv      = getfenv or function() return _ENV end;
local Setmetatable = setmetatable;
local Select       = select;

local Unpack = unpack;
local ToNumber = tonumber;local function decompress(b)local c,d,e="","",{}local f=256;local g={}for h=0,f-1 do g[h]=Char(h)end;local i=1;local function k()local l=ToNumber(Sub(b, i,i),36)i=i+1;local m=ToNumber(Sub(b, i,i+l-1),36)i=i+l;return m end;c=Char(k())e[1]=c;while i<#b do local n=k()if g[n]then d=g[n]else d=c..Sub(c, 1,1)end;g[f]=c..Sub(d, 1,1)e[#e+1],c,f=d,d,f+1 end;return table.concat(e)end;local ByteString=decompress('22P27422P22R27522R22S2751H1J181F1L22R23B2752191K1021T21A13171K1I12101L1E1J21T131O21T21D1O101F22T27526K22X24124E23W22X27426G23528A23T23527426L23528J23V28J22P26L28D22P23Y28S22P');

local BitXOR = bit and bit.bxor or function(a,b)
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

local function gBit(Bit, Start, End)
	if End then
		local Res = (Bit / 2 ^ (Start - 1)) % 2 ^ ((End - 1) - (Start - 1) + 1);

		return Res - Res % 1;
	else
		local Plc = 2 ^ (Start - 1);

        return (Bit % (Plc + Plc) >= Plc) and 1 or 0;
	end;
end;

local Pos = 1;

local function gBits32()
    local W, X, Y, Z = Byte(ByteString, Pos, Pos + 3);

	W = BitXOR(W, 97)
	X = BitXOR(X, 97)
	Y = BitXOR(Y, 97)
	Z = BitXOR(Z, 97)

    Pos	= Pos + 4;
    return (Z*16777216) + (Y*65536) + (X*256) + W;
end;

local function gBits8()
    local F = BitXOR(Byte(ByteString, Pos, Pos), 97);
    Pos = Pos + 1;
    return F;
end;

local function gFloat()
	local Left = gBits32();
	local Right = gBits32();
	local IsNormal = 1;
	local Mantissa = (gBit(Right, 1, 20) * (2 ^ 32))
					+ Left;
	local Exponent = gBit(Right, 21, 31);
	local Sign = ((-1) ^ gBit(Right, 32));
	if (Exponent == 0) then
		if (Mantissa == 0) then
			return Sign * 0; -- +-0
		else
			Exponent = 1;
			IsNormal = 0;
		end;
	elseif (Exponent == 2047) then
        return (Mantissa == 0) and (Sign * (1 / 0)) or (Sign * (0 / 0));
	end;
	return LDExp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)));
end;

local gSizet = gBits32;
local function gString(Len)
    local Str;
    if (not Len) then
        Len = gSizet();
        if (Len == 0) then
            return '';
        end;
    end;

    Str	= Sub(ByteString, Pos, Pos + Len - 1);
    Pos = Pos + Len;

	local FStr = {}
	for Idx = 1, #Str do
		FStr[Idx] = Char(BitXOR(Byte(Sub(Str, Idx, Idx)), 97))
	end

    return Concat(FStr);
end;

local gInt = gBits32;
local function _R(...) return {...}, Select('#', ...) end

local function Deserialize()
    local Instrs = { 0,0,0,0 };
    local Functions = {  };
	local Lines = {};
    local Chunk = 
	{
		Instrs,
		nil,
		Functions,
		nil,
		Lines
	};for Idx=1,gBits32() do Functions[Idx-1]=Deserialize();end;
								local ConstCount = gBits32()
    							local Consts = {0,0};

								for Idx=1,ConstCount do 
									local Type=gBits8();
									local Cons;
	
									if(Type==3) then Cons=(gBits8() ~= 0);
									elseif(Type==1) then Cons = gFloat();
									elseif(Type==2) then Cons=gString();
									end;
									
									Consts[Idx]=Cons;
								end;
								Chunk[2] = Consts
								for Idx=1,gBits32() do 
									local Data1=BitXOR(gBits32(),140);
									local Data2=BitXOR(gBits32(),236); 

									local Type=gBit(Data1,1,2);
									local Opco=gBit(Data2,1,11);
									
									local Inst=
									{
										Opco,
										gBit(Data1,3,11),
										nil,
										nil,
										Data2
									};

									if (Type == 0) then Inst[3]=gBit(Data1,12,20);Inst[5]=gBit(Data1,21,29);
									elseif(Type==1) then Inst[3]=gBit(Data2,12,33);
									elseif(Type==2) then Inst[3]=gBit(Data2,12,32)-1048575;
									elseif(Type==3) then Inst[3]=gBit(Data2,12,32)-1048575;Inst[5]=gBit(Data1,21,29);
									end;
									
									Instrs[Idx]=Inst;end;Chunk[4] = gBits8();return Chunk;end;
local function Wrap(Chunk, Upvalues, Env)
	local Instr  = Chunk[1];
	local Const  = Chunk[2];
	local Proto  = Chunk[3];
	local Params = Chunk[4];

	return function(...)
		local Instr  = Instr; 
		local Const  = Const; 
		local Proto  = Proto; 
		local Params = Params;

		local _R = _R
		local InstrPoint = 1;
		local Top = -1;

		local Vararg = {};
		local Args	= {...};

		local PCount = Select('#', ...) - 1;

		local Lupvals	= {};
		local Stk		= {};

		for Idx = 0, PCount do
			if (Idx >= Params) then
				Vararg[Idx - Params] = Args[Idx + 1];
			else
				Stk[Idx] = Args[Idx + 1];
			end;
		end;

		local Varargsz = PCount - Params + 1

		local Inst;
		local Enum;	

		while true do
			Inst		= Instr[InstrPoint];
			Enum		= Inst[1];if Enum <= 3 then if Enum <= 1 then if Enum == 0 then local A=Inst[2];local Args={};local Edx=0;local Limit=A+Inst[3]-1;for Idx=A+1,Limit do Edx=Edx+1;Args[Edx]=Stk[Idx];end;Stk[A](Unpack(Args,1,Limit-A));Top=A;else Stk[Inst[2]]=Env[Const[Inst[3]]];end; elseif Enum == 2 then do return end;else do return end;end; elseif Enum <= 5 then if Enum == 4 then Stk[Inst[2]]=Const[Inst[3]];else Stk[Inst[2]]=Env[Const[Inst[3]]];end; elseif Enum > 6 then Stk[Inst[2]]=Const[Inst[3]];else local A=Inst[2];local Args={};local Edx=0;local Limit=A+Inst[3]-1;for Idx=A+1,Limit do Edx=Edx+1;Args[Edx]=Stk[Idx];end;Stk[A](Unpack(Args,1,Limit-A));Top=A;end;
			InstrPoint	= InstrPoint + 1;
		end;
    end;
end;	
return Wrap(Deserialize(), {}, GetFEnv())();

module.exports = function() {
	return `

	local function Wrap(Chunk, Upvalues)
		local Instr	= Chunk.O_INSTR;
		local Const	= Chunk.O_CONST;
		local Proto	= Chunk.O_PROTO;

		local getinfo = Env[__debug][__getinfo]
		local info = getinfo(empty_func)

		return function(...)
			local InstrPoint, Top	= 1, -1;
			local Vararg, Varargsz	= {}, Select(Char(0x23), ...) - 1;
	
			local GStack	= {};
			local Lupvals	= {};
			local Stack		= _setmetatable({}, {
				[___index]		= GStack;
				[___newindex]	= function(_, Key, Value)
					if (Key > Top) then
						Top	= Key;
					end;
	
					GStack[Key]	= Value;
				end;
			});
	
			local function Loop()
				local Inst, Enum;
	
				while info[__linedefined] == info[__lastlinedefined] do
					Inst		= Instr[InstrPoint];
					Enum		= Inst.O_ENUM;
					InstrPoint	= InstrPoint + 1;
	
	`
}

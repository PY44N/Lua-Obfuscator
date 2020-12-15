module.exports = function() {
	return `
	local A		= Inst[1];
	local B		= Inst[2];
	local C		= Inst[3];
	local Stk	= Stack;
	
	if (C == 0) then
		InstrPoint	= InstrPoint + 1;
		C			= Instr[InstrPoint].Value;
	end;
	
	local Offset	= (C - 1) * 50;
	local T			= Stk[A]; -- Assuming T is the newly created table.
	
	if (B == 0) then
		B	= Top - A;
	end;
	
	for Idx = 1, B do
		T[Offset + Idx] = Stk[A + Idx];
	end;
	`
}

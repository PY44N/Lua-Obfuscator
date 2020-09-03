module.exports = function() {
	return `
	local A		= Inst[1];
	local Stk	= Stack;
	
	local Step	= Stk[A + 2];
	local Index	= Stk[A] + Step;
	
	Stk[A]	= Index;
	
	if (Step > 0) then
		if Index <= Stk[A + 1] then
			InstrPoint	= InstrPoint + Inst[2];
	
			Stk[A + 3] = Index;
		end;
	else
		if Index >= Stk[A + 1] then
			InstrPoint	= InstrPoint + Inst[2];
	
			Stk[A + 3] = Index;
		end
	end
	`
}

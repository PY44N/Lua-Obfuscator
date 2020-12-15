module.exports = function() {
	return `
	local A		= Inst[1];
	local C		= Inst[3];
	local Stk	= Stack;
	
	local Offset	= A + 2;
	local Result	= {Stk[A](Stk[A + 1], Stk[A + 2])};
	
	for Idx = 1, C do
		Stack[Offset + Idx] = Result[Idx];
	end;
	
	if (Stk[A + 3] ~= nil) then
		Stk[A + 2]	= Stk[A + 3];
	else
		InstrPoint	= InstrPoint + 1;
	end;
	`
}

module.exports = function() {
	return `
	local Stk	= Stack;
	local B		= Inst[2];
	local K 	= Stk[B];
	
	for Idx = B + 1, Inst[3] do
		K = K .. Stk[Idx];
	end;
	
	Stack[Inst[1]]	= K;
	`
}

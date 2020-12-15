module.exports = function() {
	return `
	local Stk	= Stack;
	
	for Idx = Inst[1], Inst[2] do
		Stk[Idx]	= nil;
	end;
	`
}

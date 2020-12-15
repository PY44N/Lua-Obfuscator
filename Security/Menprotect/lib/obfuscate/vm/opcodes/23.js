module.exports = function() {
	return `
	local Stk = Stack;
	local B = Inst[4] or Stk[Inst[2]];
	local C = Inst[5] or Stk[Inst[3]];
	
	if (B == C) ~= Inst[1] then
		InstrPoint	= InstrPoint + 1;
	end;
	`
}

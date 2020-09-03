module.exports = function() {
	return `
	local A	= Inst[1];
	local B	= Inst[2];
	local Stk, Vars	= Stack, Vararg;
	
	Top = A - 1;
	
	for Idx = A, A + (B > 0 and B - 1 or Varargsz) do
		Stk[Idx]	= Vars[Idx - A];
	end;
	`
}

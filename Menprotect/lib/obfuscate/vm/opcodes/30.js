module.exports = function() {
	return `
	local A	= Inst[1];
	local B	= Inst[2];
	local Stk	= Stack;
	local Edx, Output;
	local Limit;
	
	if (B == 1) then
		return;
	elseif (B == 0) then
		Limit	= Top;
	else
		Limit	= A + B - 2;
	end;
	
	Output = {};
	Edx = 0;
	
	for Idx = A, Limit do
		Edx	= Edx + 1;
	
		Output[Edx] = Stk[Idx];
	end;
	
	return Output, Edx;
	`
}

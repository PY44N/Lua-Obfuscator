module.exports = function() {
	return `
	local B = Stack[Inst[2]];
	
	if Inst[3] then
		if B then
			InstrPoint = InstrPoint + 1;
		else
			Stack[Inst[1]] = B
		end
	elseif B then
		Stack[Inst[1]] = B
	else
		InstrPoint = InstrPoint + 1;
	end
	`
}

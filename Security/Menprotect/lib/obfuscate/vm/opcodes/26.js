module.exports = function() {
	return `
	if Inst[3] then
		if Stack[Inst[1]] then
			InstrPoint = InstrPoint + 1;
		end
	else
		InstrPoint = InstrPoint + 1;
	end
	`
}

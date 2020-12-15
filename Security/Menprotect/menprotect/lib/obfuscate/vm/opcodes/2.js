module.exports = function() {
	return `
	Stack[Inst[1]]	= (Inst[2] ~= 0);
	
	if (Inst[3] ~= 0) then
		InstrPoint	= InstrPoint + 1;
	end;
	`
}

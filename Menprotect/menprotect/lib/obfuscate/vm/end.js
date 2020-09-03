module.exports = function() {
	return `
	end;
	end;
	
	local Args	= {...};
	
	for Idx = 0, Varargsz do
		if (Idx >= Chunk.O_ARGS) then
			Vararg[Idx - Chunk.O_ARGS] = Args[Idx + 1];
		else
			Stack[Idx] = Args[Idx + 1];
		end;
	end;
	
	local A, B, C	= Pcall(Loop);
	
	if A then
		if B and (C > 0) then
			return Unpack(B, 1, C);
		end;
	
		return;
	end;
	end;
	end;
	
	return function(bytecode)
	local buffer = parse(bytecode)

	encrypt(vm_strings[1], 0)

	__debug = vm_strings[2]
	__getinfo = vm_strings[3]

	__linedefined = vm_strings[4]
	__lastlinedefined = vm_strings[5]

	___index = vm_strings[6]
	___newindex = vm_strings[7]
	
	Wrap(buffer)()

	end
	
	`
}

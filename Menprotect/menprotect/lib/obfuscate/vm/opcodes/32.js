module.exports = function() {
    return `
    local A		= Inst[1];
    local Stk	= Stack;
    
    --[[
    -- As per mirroring the real vm
    Stk[A] = _true
    Stk[A + 1] = _true
    Stk[A + 2] = _true
    --]]
    
    Stk[A]	= Stk[A] - Stk[A + 2];
    
    InstrPoint	= InstrPoint + Inst[2];
    `
}

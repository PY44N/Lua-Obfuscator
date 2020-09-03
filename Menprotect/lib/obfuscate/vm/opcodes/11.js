module.exports = function() {
    return `
    local Stk	= Stack;
    local A		= Inst[1];
    local B		= Stk[Inst[2]];
    local C		= Inst[5] or Stk[Inst[3]];
    Stk[A + 1]	= B;
    Stk[A]		= B[C];
    `
}

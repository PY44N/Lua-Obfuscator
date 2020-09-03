module.exports = function() {
    return `
    local Stk = Stack;
    Stk[Inst[1]]	= (Inst[4] or Stk[Inst[2]]) ^ (Inst[5] or Stk[Inst[3]]);
    `
}

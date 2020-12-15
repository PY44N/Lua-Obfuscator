// Credits to rerubi, this is just a nodejs fork
// https://github.com/Rerumu/Rerubi

const print = console.log
const ldexp = require("math-float64-ldexp");

const functions = require('../funcs')
const funcs = new functions()

const Opmode = [
    {b: "OpArgR", c: "OpArgN"}, {b: "OpArgK", c: "OpArgN"}, {b: "OpArgU", c: "OpArgU"},
    {b: "OpArgR", c: "OpArgN"}, {b: "OpArgU", c: "OpArgN"}, {b: "OpArgK", c: "OpArgN"},
    {b: "OpArgR", c: "OpArgK"}, {b: "OpArgK", c: "OpArgN"}, {b: "OpArgU", c: "OpArgN"},
    {b: "OpArgK", c: "OpArgK"}, {b: "OpArgU", c: "OpArgU"}, {b: "OpArgR", c: "OpArgK"},
    {b: "OpArgK", c: "OpArgK"}, {b: "OpArgK", c: "OpArgK"}, {b: "OpArgK", c: "OpArgK"},
    {b: "OpArgK", c: "OpArgK"}, {b: "OpArgK", c: "OpArgK"}, {b: "OpArgK", c: "OpArgK"},
    {b: "OpArgR", c: "OpArgN"}, {b: "OpArgR", c: "OpArgN"}, {b: "OpArgR", c: "OpArgN"},
    {b: "OpArgR", c: "OpArgR"}, {b: "OpArgR", c: "OpArgN"}, {b: "OpArgK", c: "OpArgK"},
    {b: "OpArgK", c: "OpArgK"}, {b: "OpArgK", c: "OpArgK"}, {b: "OpArgR", c: "OpArgU"},
    {b: "OpArgR", c: "OpArgU"}, {b: "OpArgU", c: "OpArgU"}, {b: "OpArgU", c: "OpArgU"},
    {b: "OpArgU", c: "OpArgN"}, {b: "OpArgR", c: "OpArgN"}, {b: "OpArgR", c: "OpArgN"},
    {b: "OpArgN", c: "OpArgU"}, {b: "OpArgU", c: "OpArgU"}, {b: "OpArgN", c: "OpArgN"},
    {b: "OpArgU", c: "OpArgN"}, {b: "OpArgU", c: "OpArgN"}
]

const Opcode = [ // Opcode types.
    "ABC", "ABx", "ABC", "ABC",
    "ABC", "ABx", "ABC", "ABx",
    "ABC", "ABC", "ABC", "ABC",
    "ABC", "ABC", "ABC", "ABC",
    "ABC", "ABC", "ABC", "ABC",
    "ABC", "ABC", "AsBx", "ABC",
    "ABC", "ABC", "ABC", "ABC",
    "ABC", "ABC", "ABC", "AsBx",
    "AsBx", "ABC", "ABC", "ABC",
    "ABx", "ABC",
]

function gBit(Bit, Start, End) {
    if (End) {
        let Res = (Bit / Math.pow(2, Start - 1)) % Math.pow(2, (End - 1) - (Start - 1) + 1)
        return Res - Res % 1
    } else {
        let Plc = Math.pow(2, Start - 1)
        return ((Bit % (Plc + Plc) >= Plc) && 1) || 0
    }
}

module.exports = function deserialize(bytecode) {

    let used = {}
    function shuffleOpcode() {
        let op = Math.floor(Math.random() * 255)
        if (!used[op]) {
            used[op] = op
            return op
        }
        return shuffleOpcode()
    }

    let shuffle = []
    for (let i = 0; i <= 37; i++) { // Create the 38 opcodes
        shuffle.push(shuffleOpcode())
    }

    let instructions = {}

    let Pos = 0
    let gSizet
    let gInt

    function gBits8() {
        let F = bytecode.charCodeAt(Pos, Pos)
        Pos++
        return F
    }

    function gBits32() {
        let W = bytecode.charCodeAt(Pos, Pos)
        let X = bytecode.charCodeAt(Pos + 1, Pos + 1)
        let Y = bytecode.charCodeAt(Pos + 2, Pos + 2)
        let Z = bytecode.charCodeAt(Pos + 3, Pos + 3)
        Pos = Pos + 4

        return (Z * 16777216) + (Y * 65536) + (X * 256) + W
    }

    function gBits64() {
        return gBits32() * 4294967296 + gBits32()
    }

    function gFloat() {
        let Left = gBits32()
        let Right = gBits32()
        let IsNormal = 1
        let Mantissa = (gBit(Right, 1, 20) * Math.pow(2, 32)) + Left

        let Exponent = gBit(Right, 21, 31)
        let Sign = Math.pow(-1, gBit(Right, 32))

        if (Exponent == 0) {
            if (Mantissa == 0) {
                return Sign * 0
            } else {
                Exponent = 1
                IsNormal = 0
            }
        } else if (Exponent == 2047) {
            if (Mantissa == 0) {
                return Sign * (1 / 0)
            } else {
                return Sign * (0 / 0)
            }
        }

        return ldexp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / Math.pow(2, 52)))
    }

    function gString(Len) {
        let Str

        if (Len) {
            Str = bytecode.substring(Pos, Pos + Len)
            Pos = Pos + Len
        } else {
            Len = gSizet()
            if (Len == 0) return
            Str = bytecode.substring(Pos, Pos + Len)
            Pos = Pos + Len
        }

        return Str
    }
    // jesus christ {} is just cancer
    function ChunkDecode() {
        let Instr = {}
        let Const = {}
        let Proto = {}
        let Chunk = {
            Instr: Instr,
            Const: Const,
            Proto: Proto,
            Name: gString(),
            FirstL: gInt(),
            LastL: gInt(),
            Upvals: gBits8(),
            Args: gBits8(),
            Vargs: gBits8(),
            Stack: gBits8(),
        }
        let ConstantReferences = {}

        if (Chunk.Name) {
            Chunk.Name = Chunk.Name.substring(0, Chunk.Name.length - 1)
        }

        let n = 0
        let n1 = gInt()
        for (let Idx = 1; Idx <= n1; Idx++) { // load instructions
            let Data = gBits32()
            let Opco = gBit(Data, 1 , 6)
            let Type = Opcode[Opco]
            let Mode = Opmode[Opco]

            let Inst = {
                Value: Data,
                [1]: gBit(Data, 7, 14),
            }

            if (Type == "ABC") {
                Inst[2] = gBit(Data, 24, 32)
                Inst[3] = gBit(Data, 15, 23)
            } else if (Type == "ABx") {
                Inst[2]= gBit(Data, 15, 32)
            } else if (Type == "AsBx") {
                Inst[2] = gBit(Data, 15, 32) - 131071
            }

            {
                if (Opco == 26 || Opco == 27) { // TEST & TESTSET
                    Inst[3] = Inst[3] == 0
                }

                if (Opco >= 23 && Opco <= 25) { // EQ & LT & LE
                    Inst[1] = Inst[1] != 0
                }
                
                if (Mode.b == "OpArgK") {
                    // if (!Inst[3] == 0) {
                    //     Inst[3] = Inst[3] || false
                    // }
                    if (Inst[3] == 0) { // yes, I legit had to do it like this lol
                        Inst[3] = 0
                    } else {
                        Inst[3] = Inst[3] || false
                    }

                    if (Inst[2] >= 256) {
                        let Cons = Inst[2] - 256
                        Inst[4] = Cons

                        let ReferenceData = ConstantReferences[Cons]
                        if (!ReferenceData) {
                            ReferenceData = []
                            ConstantReferences[Cons] = ReferenceData
                        }

                        ReferenceData.push({
                            Inst: Inst,
                            Register: 4,
                        })
                    }
                }

                if (Mode.c == "OpArgK") {
                    Inst[4] = Inst[4] || false
                    if (Inst[3] >= 256) {
                        let Cons = Inst[3] - 256
                        Inst[5] = Cons

                        let ReferenceData = ConstantReferences[Cons]
                        if (!ReferenceData) {
                            ReferenceData = []
                            ConstantReferences[Cons] = ReferenceData
                        }

                        ReferenceData.push({
                            Inst: Inst,
                            Register: 5,
                        })
                    }
                }
            }

            let REAL_OPCODE = Opco
            let RANDOM_OPCODE = shuffle[REAL_OPCODE]

            instructions[REAL_OPCODE] = RANDOM_OPCODE // [OPCODE] = RANDOM OPCODE
            Inst.Enum = RANDOM_OPCODE
            Instr[Idx] = Inst
        }

        let n2 = gInt()
        for (let Idx = 1; Idx <= n2; Idx++) { // load constants
            let Type = gBits8()
            let Cons

            if (Type == 1) { // boolean
                Cons = gBits8() != 0
            } else if (Type == 3) { // float / double
                Cons = gFloat()
            } else if (Type == 4) {
                let s = gString()
                Cons = s.substring(0, s.length - 1)
            }

            // finish constant precomputing
            let Refs = ConstantReferences[Idx - 1]
            if (Refs) {
                for (let i = 1; i <= Refs.length; i++) {
                    Refs[i - 1].Inst[Refs[i - 1].Register] = Cons
                }
            }

            Const[Idx] = Cons
        }

        let n3 = gInt()
        for (let Idx = 1; Idx <= n3; Idx++) { // nested function prototypes
            Proto[Idx] = ChunkDecode()
        }

        { // debugging
            let Lines = Chunk.Lines

            let n4 = gInt()
            for (let Idx = 1; Idx <= n4; Idx++) { // lines
                gBits32() // line info
            }

            let n5 = gInt()
            for (let Idx = 1; Idx <= n5; Idx++) { // locals in stack
                gString() // name of locals
                gBits32() // starting point
                gBits32() // ending point
            }

            let n6 = gInt()
            for (let Idx = 1; Idx <= n6; Idx++) { // upvalues
                gString() // name of upvalues
            }
        }

        return Chunk
    }

    {
        let header = gString(4) // > "\27Lua"
        let version = gBits8() // > 0x51

        gBits8()
        gBits8()

        let IntSize = gBits8()
        let Sizet = gBits8()

        if (IntSize == 4) {
            gInt = gBits32
        } else if (IntSize == 8) {
            gInt = gBits64
        } else {
            throw "invalid integer size"
        }

        if (Sizet == 4) {
            gSizet = gBits32
        } else if (Sizet == 8) {
            gSizet = gBits64
        } else {
            throw "invalid sizet size"
        }

        let platform = gString(3)
    }

    { // Closure opcodes
        instructions[0] = Math.floor(Math.random() * 510) - 255
        instructions[4] = Math.floor(Math.random() * 510) - 255
    }

    return {
        proto: ChunkDecode(),
        instructions: instructions,
    }
}

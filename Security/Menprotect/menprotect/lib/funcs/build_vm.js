const print = console.log

const functions = require('../funcs')
const funcs = new functions()
const vmfiles = '../obfuscate/vm/'

function collect_numerics(AST) {
    let used = {}
    function shuffle() {
        let op = Math.floor(Math.random() * 255)
        if (!used[op]) {
            used[op] = op
            return op
        }
        return shuffle()
    }

    let index = {}
    function scan(chunk, callback) {
        Object.keys(chunk).forEach(function(v1) {
            let __chunk = chunk[v1]

            if (__chunk && typeof(__chunk) == 'object') { // Is chunk is valid
                let type = __chunk.type

                if (type == 'NumericLiteral' && __chunk.value) { // Macro being called
                    callback(__chunk)
                }

                scan(__chunk, callback) // Scan chunk descendants
            }
        })
    }

    let numerics = `local numerics = {`
    scan(AST, function(chunk) {
        if (!index[chunk.value]) {
            let mask = shuffle()
            
            index[chunk.value] = mask
            numerics += `[${mask}]=${chunk.value},`
            chunk.raw = `numerics[${mask}]`
            chunk.value = null
        }
    })
    numerics += `}`

    return `${numerics} `
}

module.exports = function(data, keys) {
    let proto = data.proto
    let instructions = data.instructions
    let bytecode = data.bytecode
    let mapping = data.mapping

    let build = ''
    { // Functions
        function add_source(what, ...args) {
            let data = require(`../obfuscate/vm/${what}`)
            build += data(args)
        }

        function add(string) {
            build += string
        }

        function add_opcode(opcode, ...args) {
            let data = require(`../obfuscate/vm/opcodes/${opcode}`)
            build += data(args)
        }
    }

    { // Build VM
        add_source('variables')
        add_source('parser', mapping, keys)
        add_source('init')

        { // Add opcodes
            function add_opcodes() {
                let first = true
                let keyword = 'if'

                let n = 0
                Object.keys(instructions).forEach(function(real_opcode) {
                    n++

                    let opcode = instructions[real_opcode]

                    add(`${keyword} Enum == ${opcode} then\n`)
                    add_opcode(real_opcode, keys, instructions)
                    if (first) {
                        first = false
                        keyword = 'elseif'
                    }
                })

                add(`\nend`)
            }
        }

        add_opcodes()
        add_source('end')
    }

    { // Replace stuff
        let used = []
        function ranvar(l) {
            l = l || 1
            let variable = funcs.randomstring({
                length: l,
                charset: 'alphabetic',
            })
            if (used[variable]) {
                return ranvar(l)
            }
            used[variable] = true
            return variable
        }

        let strings = {
            'O_INSTR': ranvar(),
            'O_CONST': ranvar(),
            'O_PROTO': ranvar(),
            'O_ENUM': ranvar(),
            'O_VALUE': ranvar(),
            'O_ARGS': ranvar(),
            'O_UPVALS': ranvar(),
        }

        Object.keys(strings).forEach(function(index) {
            let value = strings[index]
            build = build.split(index).join(value)
        })
    }

    let secure_byte = funcs._2C(funcs.encrypt(bytecode, keys.byte))

    let AST = funcs.parse(build)
    let numeric_index = collect_numerics(AST)

    let vm = `return(function()${funcs.minify(numeric_index + funcs.minify(AST))};end)()("${secure_byte}");`

    return `--[[
    This script was obfuscated using menprotect v1.0.0
--]]
${vm}
`
}

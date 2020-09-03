const print = console.log

const functions = require('../funcs')
const funcs = new functions()

function gMapping(index) {
    let mapping = []
    
    let used = []
    function gRan() {
        let num = Math.floor(Math.random() * index.length)
        if (used[num]) return gRan()
        used[num] = true
        return index[num]
    }

    for (let i = 1; i <= index.length; i++) {
        mapping.push(gRan())
    }
    
    return mapping
}

module.exports = function(data, keys) {
    let proto = data.proto
    let instructions = data.instructions
    let vmkey = keys.vm
    let fingerprint = keys.fingerprint

    let structureMapping = gMapping(['info', 'instructions', 'constants', 'protos'])
    let typeMapping = [0, 1, 2, 3, 4]//gMapping([1, 2, 3, 4])
    // typeMapping.push(0) // 0 has to be last for some reason

    let stream = []

    { // Stream functions
        function push(w) {
            stream.push(w)
        }

        function add_byte(n) {
            push(n)
        }

        function add_bytes(n) {
            n = n.toString()
            for (let i = 0; i < n.length; i++) {
                add_byte(parseInt(n[i]))
            }
        }

        function add_string(string) {
            for (let i = 0; i < string.length; i++) {
                push(string.charCodeAt(i, i))
            }
        }

        function add_type(x) {
            
            /*
                0:  Null
                1:  String
                2:  Int
                3:  Boolean
                4:  Float
            */

            if (typeof(x) == 'string') {

                add_byte(typeMapping[1]) // Code for string
                // add_byte(x.length) // Add length
                add_type(x.length)
                add_string(x)

            } else if (typeof(x) == 'number') {

                if (Math.abs(x) % 1 > 0) { // Is decimal
                    let pure = parseInt(x - x % 1)
                    let decimals = (x!=Math.floor(x))?(x.toString()).split('.')[1].length:0;
                    let decimal = (x - pure).toFixed(decimals)

                    add_byte(typeMapping[4]) // Code for decimal
                    
                    // Add pure number
                    add_byte(pure.toString().length)
                    add_bytes(pure)

                    // Add decimal number
                    add_byte(decimal.length - 2)
                    add_bytes(decimal.substr(2, decimal.length))

                } else { // Straight number
                    add_byte(typeMapping[2]) // Code for number
                    add_byte(x.toString().length)
                    add_bytes(x)
                }

            } else if (typeof(x) == 'boolean') {

                add_byte(typeMapping[3]) // Code for boolean
                add_byte(x == true && 1 || 0)

            } else { // NULL

                add_byte(typeMapping[0]) // Code for nil

            }

        }
    }

    function add_chunk(chunk) {

        let chunk_map = {
            info: function() {
                add_byte(chunk.Args) // Args
                add_byte(chunk.Upvals) // Upvals
            },

            instructions: function() { // Add instructions
                let c_instrutions = Object.keys(chunk.Instr) // Instructions index
                add_type(c_instrutions.length) // Add amount of instruction registers to stream
    
                for (let i = 1; i <= c_instrutions.length; i++) { // For each register, add data to stream
                    let c_register = Object.keys(chunk.Instr[i]) // Register index
                    add_byte(c_register.length)
    
                    c_register.forEach(function(index) {
                        let value = chunk.Instr[i][index] // Register value
                        add_type(value) // Add value to stream
                    })
                }
            },

            constants: function() { // Add constants
                let c_constants = Object.keys(chunk.Const) // Constants index
                add_type(c_constants.length) // Add amount of constants to stream
    
                for (let i = 1; i <= c_constants.length; i++) {
                    let constant = chunk.Const[i]
                    add_type(constant)
                }
            },

            protos: function() { // Add protos
                let c_protos = Object.keys(chunk.Proto) // Protos index
                add_type(c_protos.length) // Amount of protos
    
                for (let i = 1; i <= c_protos.length; i++) { // For each proto
                    let proto = chunk.Proto[i]
                    add_chunk(proto) // Add proto to stream
                }
            },
        }

        structureMapping.forEach(function(value, index) {
            chunk_map[value]()
        })

    }

    function add_payload(queue) {
        add_byte(queue.length)
        for (let i = 0; i < queue.length; i++) {
            add_type(funcs.encrypt(queue[i], vmkey))
        }
    }

    add_string('menprotect|') // Header
    add_byte(vmkey) // VM key
    
    add_payload([funcs.encrypt(fingerprint, 177), 'debug', 'getinfo', 'linedefined', 'lastlinedefined', '__index', '__newindex']) // General VM strings

    add_chunk(proto) // Decode chunk(s)

    return {
        stream: stream,
        mapping: {
            structure: structureMapping,
            type: typeMapping,
        },
    }
}

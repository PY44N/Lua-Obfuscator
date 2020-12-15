const print = console.log
const date = new Date()
const fs = require('fs')

const functions = require('./funcs')
const funcs = new functions()

const macros = {}
{ // Load macros
    macros.MP_PROTECT = require('./obfuscate/macros/MP_PROTECT')
    macros.MP_CRASH = require('./obfuscate/macros/MP_CRASH')
    macros.MP_JUNK = require('./obfuscate/macros/MP_JUNK')
    macros.MP_ID = require('./obfuscate/macros/MP_ID')
    macros.MP_RANDOM = require('./obfuscate/macros/MP_RANDOM')
}

const mutations = {}
{ // Load mutation handlers
    require('./obfuscate/mutations/BinaryExpression').init(mutations)
}

module.exports = function(options) {
    let start = funcs.get_mili_time()

    let stats = {
        fingerprint: funcs.randomstring(12),
        mutations: 0,
    }

    let keys = {
        fingerprint: stats.fingerprint,
        vm: Math.floor(Math.random() * 50) + 11,
        byte: Math.floor(Math.random() * 50) + 11,
    }

    let script = options.script || `do end`
    let callback = options.callback || function(){}
    let specified_options = options.options || {}

    let state = function(body) { // Change in states
        let func = options.state || function(){}
        func({
            body: body,
        })
    }

    let log = function(body, status) { // Logs

        /*
            1: SUCCESS (DEFAULT)
            2: WARNING
            3: ERROR
        */

        let func = options.log || function(){}
        func({
            body: body,
            status: status,
        })
    }

    state('Initializing')

    try { // AST Handler
        let AST = funcs.parse(script)
        state('Mapping')
        function scan(chunk) {
            Object.keys(chunk).forEach(function(v1) {
                let __chunk = chunk[v1]

                if (__chunk && typeof(__chunk) == 'object') { // Is chunk is valid
                    let type = __chunk.type

                    if (type == 'CallExpression') { // Macro being called
                        let base = __chunk.base
                        let args = __chunk.arguments
                        let func = base.name // Function name (Macro)

                        if (macros[func]) { // Is calling macro
                            let handler = macros[func].handler || function(){}
                            handler(__chunk) // Call macro with chunk data
                            log(`MACRO USED : "${func}"`)
                        }
                    }

                    if (specified_options.mutations.enabled) {
                        if (mutations[type]) { // Mutation handler
                            mutations[type].fire({
                                options: specified_options,
                                stats: stats,
                                subchunk: chunk,
                                idx: v1,
                            })
                        }
                    }

                    scan(__chunk) // Scan chunk descendants
                }
            })
        }

        scan(AST.body) // Start macro scanning

        let source = funcs.minify(AST)
        script = '' // Clear script

        Object.keys(macros).forEach(function(macro) { // For each macro, add lua function
            let macroData = macros[macro]
            let addon = macroData.addon || ``
            let static = macroData.static || `return(...)`
            script += `\n${addon}\nlocal function ${macro}(...) ${static} end\n`
        })

        script += source // Add script back
        if (options.debug) {
            fs.writeFileSync('./menprotect/ast.lua', script)
        };
    } catch (err) {
        return log(`${err.toString()}`, 3)
    }

    state('Compiling function')
    funcs.compile(script).then(function(bytecode) { // Compile script

        state('Deserializing')
        let deserialized = funcs.deserialize(bytecode) // Deserialize bytecode into a proto structure

        state('Generating stream')
        let reserialized = funcs.reserialize(deserialized, keys) // Convert proto structure into a bytecode stream

        state('Converting')
        let mp_bytecode = funcs.convertstream(reserialized.stream) // Convert bytecode stream into a string

        state('Building VM')
        let vm = funcs.build_vm({
            proto: deserialized.proto,
            instructions: deserialized.instructions,
            bytecode: mp_bytecode,
            mapping: reserialized.mapping,
        }, keys)

        // print(funcs._2C(bytecode))
        // print(funcs._2C(mp_bytecode))
        // print(deserialized.proto)

        { // Return
            let time = parseFloat((funcs.get_mili_time() - start).toString().substring(0, 6))
            stats.time = time
            state('Done !')
            callback({
                stats: stats,
                script: vm,
            })
        }
    })
}

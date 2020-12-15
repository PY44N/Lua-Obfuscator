const print = console.log

const functions = require('../../funcs')
const funcs = new functions()

const handle = 'BinaryExpression'

const poles = {
    EQ: {
        ['==']: '~=',
        ['~=']: '==',
    },

    arithmetic: {
        ['+']: '-',
        ['-']: '+',
        ['*']: '/',
        ['/']: '*',
    }
}

module.exports = {
    init: function(mutations) {
        funcs.mutation_handler(mutations, handle) // Init mutation
        mutations[handle].connect(function(data) { // Mutation handler

            let options = data.options
            let stats = data.stats
            let chunk = data.subchunk[data.idx]

            if (chunk.operator && poles.EQ[chunk.operator]) { // EQ handler

                if (options.mutations.max.enabled) {
                    if (stats.mutations >= options.mutations.max.amount) return
                }
                
                stats.mutations++

                data.subchunk[data.idx] = {
                    type: 'UnaryExpression',
                    operator: 'not',
                    argument: {
                        type: chunk.type,
                        operator: poles.EQ[chunk.operator],
                        left: chunk.left,
                        right: chunk.right,
                    },
                }

            }

            if (chunk.operator && poles.arithmetic[chunk.operator]) {

                function handle_arithmetic(data) {

                    function gEquation(n) { // Generate random equation that will return `n`
                        if (options.mutations.max.enabled) {
                            if (stats.mutations >= options.mutations.max.amount) return
                        }
                        
                        stats.mutations++

                        let re = Math.floor(Math.random() * 2) + 1
                        let method = re == 1 && '+' || re == 2 && '-' || re == 3 && '*' || re == 4 && '/'

                        function hMethod(A, B) {
                            if (re == 1) { // +
                                return A + B
                            } else if (re == 2) { // -
                                return A - B
                            } else if (re == 3) { // *
                                return A * B
                            } else if (re == 4) { // /
                                return A / B
                            }
                        }

                        let r = Math.floor(Math.random() * 50) + 10 // Generate random key
                        let m = hMethod(n, r) // Generate equation from key

                        return `(${m} ${poles.arithmetic[method]} ${r})` // Return equation
                    }

                    if (data.type == 'NumericLiteral' && data.value) {
                        data.raw = gEquation(data.value)
                    }
                }

                handle_arithmetic(chunk.left)
                handle_arithmetic(chunk.right)

            }

        })
    },
}

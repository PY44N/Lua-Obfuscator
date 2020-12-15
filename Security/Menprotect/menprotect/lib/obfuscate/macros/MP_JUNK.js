const __options = {
    max: 10,
}

const print = console.log

const functions = require('../../funcs')
const funcs = new functions()

function gRandom(n) {
    n = n || 10
    return Math.floor(Math.random() * 10) + 5
}

function gBoolean() {
    return Math.floor(Math.random() * 2) == 1 && true
}

function gJunk() {
    let fill = {
        constants: gBoolean(),
        forloop: gBoolean(),
        tables: gBoolean(),
        eq: gBoolean(),
        protos: gBoolean(),
    }

    let closure_start = `function()\n`
    let closure_end = `\nend`
    let closure = ``

    if (fill.constants) { // Junk constants
        for (let i = 0; i < gRandom(); i++) {
            closure += `local ${('_').repeat(i + 1)} = '${funcs.randomstring(gRandom())}'`
        }
    }

    if (fill.constants) { // Junk constants
        for (let i = 0; i < gRandom(); i++) {
            closure += `local ${('_').repeat(i + 1)} = {}`
        }
    }

    if (fill.forloop) { // Junk forloops
        closure += `
        for i = ${gRandom()}, ${gRandom()} do
        end
        `
    }

    if (fill.eq) {
        for (let i = 0; i < gRandom(); i++) {
            let not = gBoolean() && 'not' || ''
            let eq = gBoolean() && '==' || '~='
            closure += `
            if ${not} ${gBoolean().toString()} ${eq} ${gBoolean().toString()} then
            end
            `
        }
    }

    if (fill.protos ) { // Junk protos
        closure += `local _${funcs.randomstring(8)} = ${gJunk()}`
    }

    let fClosure = closure_start + closure + closure_end
    return fClosure
}

module.exports = {
    handler: function(chunk) {
        let args = chunk.arguments
        let arg = args[0]
    
        let intensity = parseInt(arg && arg.type == 'NumericLiteral' && arg.value || 1) // Intensity value
        intensity = intensity < 1 && 1 || intensity // MIN intensity value
        intensity = intensity > __options.max && __options.max || intensity // MAX intensity value
    
        for (let i = 0; i < intensity; i++) {
            args[i] = {
                type: 'StringLiteral',
                value: null,
                raw: gJunk(),
            }
        }
    },
}

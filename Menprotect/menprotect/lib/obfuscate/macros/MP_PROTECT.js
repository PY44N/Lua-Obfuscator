const print = console.log

const functions = require('../../funcs')
const funcs = new functions()

function serialize(s) {
    let cs = []
    for (let i = 0; i < s.length; i++) {
        cs.push(s.charCodeAt(i))
    }
    return cs
}

function deserialize(cs) {
    let A = ""
    cs.forEach(function(value) {
        A += String.fromCharCode(value)
    })
    return A
}

function encrypt(s) {
    function gKey(l) {
        let fragments = []
        for (let i = 0; i < l; i++) {
            fragments[i] = Math.floor(Math.random() * 254) + 1
        }
        return fragments
    }

    let key = gKey(s.length)

    let new_string = []
    serialize(s).forEach(function(value, index) {
        new_string.push(funcs.xor(value, key[index]))
    })

    return {
        string: deserialize(new_string),
        key: deserialize(key),
    }
}

function gstr(s, k) {
    return `(function(a,b)local function c(d,e)local f,g=1,0;while d>0 and e>0 do local h,i=d%2,e%2;if h~=i then g=g+f end;d,e,f=(d-h)/2,(e-i)/2,f*2 end;if d<e then d=e end;while d>0 do local h=d%2;if h>0 then g=g+f end;d,f=(d-h)/2,f*2 end;return g end;local function j(a,b)local k={}for l=1,#a do k[l]=string.char(c(string.byte(a,l,l),string.byte(b,l,l)))end;return table.concat(k)end;return j(a,b)end)("${funcs._2C(s)}","${funcs._2C(k)}")`
}

function gEquation(n) { // Generate random equation that will return `n`
    const poles = {
        arithmetic: {
            ['+']: '-',
            ['-']: '+',
            ['*']: '/',
            ['/']: '*',
        }
    }

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

    let r = Math.floor(Math.random() * 1000) + 100 // Generate random key
    let m = hMethod(n, r) // Generate equation from key

    return `(${m} ${poles.arithmetic[method]} ${r})` // Return equation
}

module.exports = {
    handler: function(chunk) {
        let args = chunk.arguments
        let arg = args[0]
    
        if (arg.type == 'StringLiteral') { // If first argument is string
            let string = arg.raw.substring(1, arg.raw.length - 1) // Raw string, remove first and last character (\"\")
            let data = encrypt(string)
            arg.raw = gstr(data.string, data.key)
        }

        if (arg.type == 'NumericLiteral') { // If first argument is <int / float>
            // if (arg.value && arg.raw) {
            //     arg.raw = gEquation(arg.value)
            // }
        }

    },
}

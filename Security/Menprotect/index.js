const print = console.log

module.exports = class menprotect {
    constructor() {
        this.version = '1.0.0'
        this.obfuscate = require('./lib/obfuscate')
    }
}

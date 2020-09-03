const randomstring = require('randomstring').generate
const { spawn } = require('child_process')
const fs = require('fs')

module.exports = function(script) {
    return new Promise(function(resolve, reject) {
        let Files = [
            `${randomstring(5)}.lua`,
            `${randomstring(5)}.out`
        ]
    
        fs.writeFileSync(`./${Files[0]}`, script)
    
        let Process = spawn("luac", [
            "-o",
            `./${Files[1]}`,
            `./${Files[0]}`
        ])
        Process.on("exit", function() {
            resolve(fs.readFileSync(`./${Files[1]}`, 'binary'))
            fs.unlinkSync(`./${Files[1]}`)
            fs.unlinkSync(`./${Files[0]}`)
        })
    })
}

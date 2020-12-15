module.exports = function() {
    const hrTime = process.hrtime()
    return hrTime[0] * 1000 + hrTime[1] / 1000000
}

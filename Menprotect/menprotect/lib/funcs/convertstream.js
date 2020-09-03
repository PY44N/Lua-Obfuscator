module.exports = function(stream) {
    let new_stream = ''
    for (let i = 0; i < stream.length; i++) {
        new_stream += String.fromCharCode(stream[i])
    }
    return new_stream
}

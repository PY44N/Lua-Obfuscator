module.exports = function(a, b) {
    let p = 1
    let c = 0

    while (a > 0 && b > 0) {
        let ra = a % 2
        let rb = b % 2

        if (ra != rb) {
            c = c + p
        }
        
        a = (a - ra) / 2
        b = (b - rb) / 2
        p = p * 2
    }

    if (a < b) {
        a = b
    }

	while (a > 0) {
        let ra = a % 2

		if (ra > 0) {
			c = c + p
        }

        a = (a - ra) / 2
        p = p * 2
    }

    return c
}

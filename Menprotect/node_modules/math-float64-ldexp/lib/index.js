'use strict';

// NOTES //

/**
* Notes:
*	=> ldexp: load exponent (see [The Open Group]{@link http://pubs.opengroup.org/onlinepubs/9699919799/functions/ldexp.html}).
*/


// MODULES //

var PINF = require( 'const-pinf-float64' );
var NINF = require( 'const-ninf-float64' );
var normalize = require( 'math-float64-normalize' );
var floatExp = require( 'math-float64-exponent' );
var copysign = require( 'math-float64-copysign' );
var toWords = require( 'math-float64-to-words' );
var fromWords = require( 'math-float64-from-words' );


// VARIABLES //

var BIAS = 1023;

// -(BIAS+(52-1)) = -(1023+51) = -1074
var MIN_SUBNORMAL_EXPONENT = -1074;

// -BIAS = -1023
var MAX_SUBNORMAL_EXPONENT = -BIAS;

// 11111111110 => 2046 - BIAS = 1023
var MAX_EXPONENT = BIAS;

// 1/(1<<52) = 1/(2**52) = 1/4503599627370496
var TWO52_INV = 2.220446049250313e-16;

// Exponent all 0s: 10000000000011111111111111111111
var CLEAR_EXP_MASK = 0x800fffff; // 2148532223


// LDEXP //

/**
* FUNCTION: ldexp( frac, exp )
*	Multiplies a double-precision floating-point number by an integer power of two.
*
* @param {Number} frac - fraction
* @param {Number} exp - exponent
* @returns {Number} double-precision floating-point number
*/
function ldexp( frac, exp ) {
	var high;
	var tmp;
	var w;
	var m;
	if (
		frac === 0 || // handles +-0
		frac !== frac || // handles NaN
		frac === PINF ||
		frac === NINF
	) {
		return frac;
	}
	// Normalize the input fraction:
	tmp = normalize( frac );
	frac = tmp[ 0 ];
	exp += tmp[ 1 ];

	// Extract the exponent from `frac` and add it to `exp`:
	exp += floatExp( frac );

	// Check for underflow/overflow...
	if ( exp < MIN_SUBNORMAL_EXPONENT ) {
		return copysign( 0, frac );
	}
	if ( exp > MAX_EXPONENT ) {
		if ( frac < 0 ) {
			return NINF;
		}
		return PINF;
	}
	// Check for a subnormal and scale accordingly to retain precision...
	if ( exp <= MAX_SUBNORMAL_EXPONENT ) {
		exp += 52;
		m = TWO52_INV;
	} else {
		m = 1.0;
	}
	// Split the fraction into higher and lower order words:
	w = toWords( frac );
	high = w[ 0 ];

	// Clear the exponent bits within the higher order word:
	high &= CLEAR_EXP_MASK;

	// Set the exponent bits to the new exponent:
	high |= ((exp+BIAS) << 20);

	// Create a new floating-point number:
	return m * fromWords( high, w[ 1 ] );
} // end FUNCTION ldexp()


// EXPORTS //

module.exports = ldexp;

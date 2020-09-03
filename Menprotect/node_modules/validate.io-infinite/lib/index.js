'use strict';

// VARIABLES //

var pinf = Number.POSITIVE_INFINITY;
var ninf = Number.NEGATIVE_INFINITY;


// IS INFINITE //

/**
* FUNCTION: isInfinite( x )
*	Validates if a value is infinite.
*
* @param {*} x - value to validate
* @returns {Boolean} boolean indicating if a value is infinite
*/
function isInfinite( x ) {
	return ( x === pinf || x === ninf );
} // end FUNCTION isInfinite()


// EXPORTS //

module.exports = isInfinite;

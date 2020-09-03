'use strict';

// MODULES //

var isLittleEndian = require( 'utils-is-little-endian' );


// INDICES //

var HIGH;
var LOW;

if ( isLittleEndian ) {
	HIGH = 1; // second index
	LOW = 0; // first index
} else {
	HIGH = 0; // first index
	LOW = 1; // second index
}


// EXPORTS //

module.exports = {
	'HIGH': HIGH,
	'LOW': LOW
};

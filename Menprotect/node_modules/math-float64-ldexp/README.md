ldexp
===
[![NPM version][npm-image]][npm-url] [![Build Status][build-image]][build-url] [![Coverage Status][coverage-image]][coverage-url] [![Dependencies][dependencies-image]][dependencies-url]

> Multiplies a [double-precision floating-point number][ieee754] by an integer power of two.


## Installation

``` bash
$ npm install math-float64-ldexp
```


## Usage

``` javascript
var ldexp = require( 'math-float64-ldexp' );
```

#### ldexp( frac, exp )

Multiplies a [double-precision floating-point number][ieee754] by an `integer` power of two; i.e., `x = frac * 2**exp`.

``` javascript
var x = ldexp( 0.5, 3 ); // => 0.5 * 2**3 = 0.5 * 8
// returns 4

x = ldexp( 4, -2 ); // => 4 * 2**(-2) = 4 * (1/4)
// returns 1
```

If `frac` equals positive or negative `zero`, `NaN`, or positive or negative `infinity`, the `function` returns a value equal to `frac`.

``` javascript
var x = ldexp( 0, 20 );
// returns 0

x = ldexp( -0, 39 );
// returns -0

x = ldexp( NaN, -101 );
// returns NaN

x = ldexp( Number.POSITIVE_INFINITY, 11 );
// returns +infinity

x = ldexp( Number.NEGATIVE_INFINITY, -118 );
// returns -infinity
```


## Notes

*	This `function` is the inverse of [`frexp`][math-float64-frexp].


## Examples

``` javascript
var round = require( 'math-round' );
var pow = require( 'math-power' );
var frexp = require( 'math-float64-frexp' );
var ldexp = require( 'math-float64-ldexp' );

var sign;
var frac;
var exp;
var x;
var f;
var v;
var i;

/**
* 1) Generate random numbers.
* 2) Break each number into a normalized fraction and an integer power of two.
* 3) Reconstitute the original number.
*/
for ( i = 0; i < 100; i++ ) {
	if ( Math.random() < 0.5 ) {
		sign = -1;
	} else {
		sign = 1;
	}
	frac = Math.random() * 10;
	exp = round( Math.random()*616 ) - 308;
	x = sign * frac * pow( 10, exp );
	f = frexp( x );
	v = ldexp( f[ 0 ], f[ 1 ] );
	console.log( '%d = %d * 2^%d = %d', x, f[ 0 ], f[ 1 ], v );
}
```

To run the example code from the top-level application directory,

``` bash
$ node ./examples/index.js
```


---
## Tests

### Unit

This repository uses [tape][tape] for unit tests. To run the tests, execute the following command in the top-level application directory:

``` bash
$ make test
```

All new feature development should have corresponding unit tests to validate correct functionality.


### Test Coverage

This repository uses [Istanbul][istanbul] as its code coverage tool. To generate a test coverage report, execute the following command in the top-level application directory:

``` bash
$ make test-cov
```

Istanbul creates a `./reports/coverage` directory. To access an HTML version of the report,

``` bash
$ make view-cov
```


### Browser Support

This repository uses [Testling][testling] for browser testing. To run the tests in a (headless) local web browser, execute the following command in the top-level application directory:

``` bash
$ make test-browsers
```

To view the tests in a local web browser,

``` bash
$ make view-browser-tests
```

<!-- [![browser support][browsers-image]][browsers-url] -->


---
## License

[MIT license](http://opensource.org/licenses/MIT).


## Copyright

Copyright &copy; 2016. The [Compute.io][compute-io] Authors.


[npm-image]: http://img.shields.io/npm/v/math-float64-ldexp.svg
[npm-url]: https://npmjs.org/package/math-float64-ldexp

[build-image]: http://img.shields.io/travis/math-io/float64-ldexp/master.svg
[build-url]: https://travis-ci.org/math-io/float64-ldexp

[coverage-image]: https://img.shields.io/codecov/c/github/math-io/float64-ldexp/master.svg
[coverage-url]: https://codecov.io/github/math-io/float64-ldexp?branch=master

[dependencies-image]: http://img.shields.io/david/math-io/float64-ldexp.svg
[dependencies-url]: https://david-dm.org/math-io/float64-ldexp

[dev-dependencies-image]: http://img.shields.io/david/dev/math-io/float64-ldexp.svg
[dev-dependencies-url]: https://david-dm.org/dev/math-io/float64-ldexp

[github-issues-image]: http://img.shields.io/github/issues/math-io/float64-ldexp.svg
[github-issues-url]: https://github.com/math-io/float64-ldexp/issues

[tape]: https://github.com/substack/tape
[istanbul]: https://github.com/gotwarlost/istanbul
[testling]: https://ci.testling.com

[compute-io]: https://github.com/compute-io/
[ieee754]: https://en.wikipedia.org/wiki/IEEE_754-1985
[math-float64-frexp]: https://github.com/math-io/float64-frexp

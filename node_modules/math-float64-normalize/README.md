Normalize
===
[![NPM version][npm-image]][npm-url] [![Build Status][build-image]][build-url] [![Coverage Status][coverage-image]][coverage-url] [![Dependencies][dependencies-image]][dependencies-url]

> Returns a normal number `y` and exponent `exp` satisfying `x = y * 2^exp`.


## Installation

``` bash
$ npm install math-float64-normalize
```


## Usage

``` javascript
var normalize = require( 'math-float64-normalize' );
```

#### normalize( x )

Returns a normal number `y` and exponent `exp` satisfying `x = y * 2^exp`.

``` javascript
var out = normalize( 3.14e-319 );
// returns [ 1.4141234400356668e-303, -52 ]
```

The first element of the returned `array` corresponds to `y` and the second to `exp`.

``` javascript
var pow = require( 'math-power' );

var y = out[ 0 ];
var exp = out[ 1 ];

var bool = ( y*pow(2,exp) === 3.14e-319 );
// returns true
```

The `function` expects a finite, non-zero `numeric` value `x`. If `x == 0`,

``` javascript
var out = normalize( 0 );
// returns [ 0, 0 ];
```

If `x` is either positive or negative `infinity` or `NaN`,

``` javascript
var pinf = require( 'const-pinf-float64' );
var ninf = require( 'const-ninf-float64' );

var out = normalize( pinf );
// returns [ pinf, 0 ]

out = normalize( ninf );
// returns [ ninf, 0 ]

out = normalize( NaN );
// returns [ NaN, 0 ]
```


## Examples

``` javascript
var round = require( 'math-round' );
var pow = require( 'math-power' );
var normalize = require( 'math-float64-normalize' );

var frac;
var exp;
var x;
var v;
var i;

// Generate denormalized numbers and then normalize them...
for ( i = 0; i < 100; i++ ) {
	// Generate a random fraction:
	frac = Math.random() * 10;

	// Generate an exponent on the interval (-308,-324):
	exp = -309 - round( Math.random()*14 );

	// Create a subnormal number (~2.23e-308, ~4.94e-324):
	x = frac * pow( 10, exp );

	// Determine a `y` and an `exp` to "normalize" the subnormal:
	v = normalize( x );

	console.log( '%d = %d * 2^%d = %d', x, v[0], v[1], v[0]*pow(2,v[1]) );
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


[npm-image]: http://img.shields.io/npm/v/math-float64-normalize.svg
[npm-url]: https://npmjs.org/package/math-float64-normalize

[build-image]: http://img.shields.io/travis/math-io/float64-normalize/master.svg
[build-url]: https://travis-ci.org/math-io/float64-normalize

[coverage-image]: https://img.shields.io/codecov/c/github/math-io/float64-normalize/master.svg
[coverage-url]: https://codecov.io/github/math-io/float64-normalize?branch=master

[dependencies-image]: http://img.shields.io/david/math-io/float64-normalize.svg
[dependencies-url]: https://david-dm.org/math-io/float64-normalize

[dev-dependencies-image]: http://img.shields.io/david/dev/math-io/float64-normalize.svg
[dev-dependencies-url]: https://david-dm.org/dev/math-io/float64-normalize

[github-issues-image]: http://img.shields.io/github/issues/math-io/float64-normalize.svg
[github-issues-url]: https://github.com/math-io/float64-normalize/issues

[tape]: https://github.com/substack/tape
[istanbul]: https://github.com/gotwarlost/istanbul
[testling]: https://ci.testling.com

[compute-io]: https://github.com/compute-io/

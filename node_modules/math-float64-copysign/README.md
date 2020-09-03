Copysign
===
[![NPM version][npm-image]][npm-url] [![Build Status][build-image]][build-url] [![Coverage Status][coverage-image]][coverage-url] [![Dependencies][dependencies-image]][dependencies-url]

> Returns a [double-precision floating-point number][ieee754] with the magnitude of `x` and the sign of `y`.


## Installation

``` bash
$ npm install math-float64-copysign
```


## Usage

``` javascript
var copysign = require( 'math-float64-copysign' );
```

#### copysign( x, y )

Returns a [double-precision floating-point number][ieee754] with the magnitude of `x` and the sign of `y`.

``` javascript
var z = copysign( -3.14, 10 );
// returns 3.14

z = copysign( 3.14, -1 );
// returns -3.14

z = copysign( 1, -0 );
// returns -1

z = copysign( -3.14, -0 );
// returns -3.14

z = copysign( -0, 1 );
// returns 0
```


## Notes

*	According to the [IEEE754][ieee754] standard, a `NaN` has a biased exponent equal to `2047`, a significand greater than `0`, and a sign bit equal to __either__ `1` __or__ `0`. In which case, `NaN` may not correspond to just one but many binary representations. Accordingly, care should be taken to ensure that `y` is __not__ `NaN`, else behavior may be indeterminate.


## Examples

``` javascript
var copysign = require( 'math-float64-copysign' );

var x;
var y;
var z;
var i;

// Generate random double-precision floating-point numbers `x` and `y` and copy the sign of `y` to `x`...
for ( i = 0; i < 100; i++ ) {
	x = Math.random()*100 - 50;
	y = Math.random()*10 - 5;
	z = copysign( x, y );
	console.log( 'x: %d, y: %d => %d', x, y, z );
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


[npm-image]: http://img.shields.io/npm/v/math-float64-copysign.svg
[npm-url]: https://npmjs.org/package/math-float64-copysign

[build-image]: http://img.shields.io/travis/math-io/float64-copysign/master.svg
[build-url]: https://travis-ci.org/math-io/float64-copysign

[coverage-image]: https://img.shields.io/codecov/c/github/math-io/float64-copysign/master.svg
[coverage-url]: https://codecov.io/github/math-io/float64-copysign?branch=master

[dependencies-image]: http://img.shields.io/david/math-io/float64-copysign.svg
[dependencies-url]: https://david-dm.org/math-io/float64-copysign

[dev-dependencies-image]: http://img.shields.io/david/dev/math-io/float64-copysign.svg
[dev-dependencies-url]: https://david-dm.org/dev/math-io/float64-copysign

[github-issues-image]: http://img.shields.io/github/issues/math-io/float64-copysign.svg
[github-issues-url]: https://github.com/math-io/float64-copysign/issues

[tape]: https://github.com/substack/tape
[istanbul]: https://github.com/gotwarlost/istanbul
[testling]: https://ci.testling.com

[compute-io]: https://github.com/compute-io/
[ieee754]: https://en.wikipedia.org/wiki/IEEE_754-1985
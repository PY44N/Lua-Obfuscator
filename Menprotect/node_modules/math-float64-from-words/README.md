toFloat64
===
[![NPM version][npm-image]][npm-url] [![Build Status][build-image]][build-url] [![Coverage Status][coverage-image]][coverage-url] [![Dependencies][dependencies-image]][dependencies-url]

> Creates a [double-precision floating-point number][ieee754] from a higher order word and a lower order word.


## Installation

``` bash
$ npm install math-float64-from-words
```


## Usage

``` javascript
var toFloat64 = require( 'math-float64-from-words' );
```

#### toFloat64( high, low )

Creates a [double-precision floating-point number][ieee754] from a higher order word (unsigned 32-bit `integer`) and a lower order word (unsigned 32-bit `integer`).

``` javascript
var val = toFloat64( 1774486211, 2479577218 );
// returns 3.14e201

val = toFloat64( 3221823995, 1413754136 );
// returns 3.141592653589793

val = toFloat64( 0, 0 );
// returns 0

val = toFloat64( 2147483648, 0 );
// returns -0

val = toFloat64( 2146959360, 0 );
// returns NaN

val = toFloat64( 2146435072, 0 );
// returns +infinity

val = toFloat64( 4293918720, 0 );
// returns -infinity
```


## Notes

*	For more information regarding higher and lower order words, see [math-float64-to-words][math-float64-to-words].


## Examples

``` javascript
var round = require( 'math-round' );
var pow = require( 'math-power' );
var toFloat64 = require( 'math-float64-from-words' );

var MAX_UINT;
var high;
var low;
var x;
var i;

MAX_UINT = pow( 2, 32 ) - 1;
for ( i = 0; i < 100; i++ ) {
	high = round( Math.random()*MAX_UINT );
	low = round( Math.random()*MAX_UINT );
	x = toFloat64( high, low );
	console.log( 'higher: %d. lower: %d. float: %d.', high, low, x );
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


[npm-image]: http://img.shields.io/npm/v/math-float64-from-words.svg
[npm-url]: https://npmjs.org/package/math-float64-from-words

[build-image]: http://img.shields.io/travis/math-io/float64-from-words/master.svg
[build-url]: https://travis-ci.org/math-io/float64-from-words

[coverage-image]: https://img.shields.io/codecov/c/github/math-io/float64-from-words/master.svg
[coverage-url]: https://codecov.io/github/math-io/float64-from-words?branch=master

[dependencies-image]: http://img.shields.io/david/math-io/float64-from-words.svg
[dependencies-url]: https://david-dm.org/math-io/float64-from-words

[dev-dependencies-image]: http://img.shields.io/david/dev/math-io/float64-from-words.svg
[dev-dependencies-url]: https://david-dm.org/dev/math-io/float64-from-words

[github-issues-image]: http://img.shields.io/github/issues/math-io/float64-from-words.svg
[github-issues-url]: https://github.com/math-io/float64-from-words/issues

[tape]: https://github.com/substack/tape
[istanbul]: https://github.com/gotwarlost/istanbul
[testling]: https://ci.testling.com

[compute-io]: https://github.com/compute-io/
[ieee754]: https://en.wikipedia.org/wiki/IEEE_754-1985
[math-float64-to-words]: https://github.com/math-io/float64-to-words

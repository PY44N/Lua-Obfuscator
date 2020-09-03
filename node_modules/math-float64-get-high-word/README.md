High Word
===
[![NPM version][npm-image]][npm-url] [![Build Status][build-image]][build-url] [![Coverage Status][coverage-image]][coverage-url] [![Dependencies][dependencies-image]][dependencies-url]

> Returns an unsigned 32-bit integer corresponding to the more significant 32 bits of a [double-precision floating-point number][ieee754].


## Installation

``` bash
$ npm install math-float64-get-high-word
```


## Usage

``` javascript
var highWord = require( 'math-float64-get-high-word' );
```

#### highWord( x )

Returns an unsigned 32-bit `integer` corresponding to the more significant 32 bits of a [double-precision floating-point number][ieee754].

``` javascript
var w = highWord( 3.14e201 );
// returns 1774486211 => 01101001110001001000001011000011
```


## Examples

``` javascript
var floor = require( 'math-floor' );
var pow = require( 'math-power' );
var highWord = require( 'math-float64-get-high-word' );

var frac;
var exp;
var w;
var x;
var i;

for ( i = 0; i < 100; i++ ) {
	frac = Math.random() * 10;
	exp = -floor( Math.random()*324 );
	x = frac * pow( 10, exp );
	w = highWord( x );
	console.log( 'x: %d. high word: %d.', x, w );
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


[npm-image]: http://img.shields.io/npm/v/math-float64-get-high-word.svg
[npm-url]: https://npmjs.org/package/math-float64-get-high-word

[build-image]: http://img.shields.io/travis/math-io/float64-get-high-word/master.svg
[build-url]: https://travis-ci.org/math-io/float64-get-high-word

[coverage-image]: https://img.shields.io/codecov/c/github/math-io/float64-get-high-word/master.svg
[coverage-url]: https://codecov.io/github/math-io/float64-get-high-word?branch=master

[dependencies-image]: http://img.shields.io/david/math-io/float64-get-high-word.svg
[dependencies-url]: https://david-dm.org/math-io/float64-get-high-word

[dev-dependencies-image]: http://img.shields.io/david/dev/math-io/float64-get-high-word.svg
[dev-dependencies-url]: https://david-dm.org/dev/math-io/float64-get-high-word

[github-issues-image]: http://img.shields.io/github/issues/math-io/float64-get-high-word.svg
[github-issues-url]: https://github.com/math-io/float64-get-high-word/issues

[tape]: https://github.com/substack/tape
[istanbul]: https://github.com/gotwarlost/istanbul
[testling]: https://ci.testling.com

[compute-io]: https://github.com/compute-io/
[ieee754]: https://en.wikipedia.org/wiki/IEEE_754-1985

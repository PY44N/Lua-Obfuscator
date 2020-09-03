SMALLEST FLOAT64
===
[![NPM version][npm-image]][npm-url] [![Build Status][build-image]][build-url] [![Coverage Status][coverage-image]][coverage-url] [![Dependencies][dependencies-image]][dependencies-url]

> Smallest positive [double-precision floating-point number][ieee754].


## Installation

``` bash
$ npm install const-smallest-float64
```


## Usage

``` javascript
var SMALLEST_FLOAT64 = require( 'const-smallest-float64' );
```

#### SMALLEST_FLOAT64

An `object` comprised as follows:

``` javascript
{
	'VALUE': 2.2250738585072014e-308,
	'DENORMALIZED': ~4.94e-324
}
```


##### Value

Smallest positive __normalized__ [double-precision floating-point number][ieee754].

``` javascript
SMALLEST_FLOAT64.VALUE === Math.pow( 2, -(1023-1) );
```


##### Denormalized

Smallest positive __denormalized__ [double-precision floating-point number][ieee754].

``` javascript
SMALLEST_FLOAT64.DENORMALIZED === Math.pow( 2, -(1023-1+52) );
```


## Examples

``` javascript
var SMALLEST_FLOAT64 = require( 'const-smallest-float64' );

console.log( SMALLEST_FLOAT64.VALUE );
// returns 2.2250738585072014e-308

console.log( SMALLEST_FLOAT64.DENORMALIZED );
// returns ~4.94e-324
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

Copyright &copy; 2016. The [Compute.io][compute-io] Authors..


[npm-image]: http://img.shields.io/npm/v/const-smallest-float64.svg
[npm-url]: https://npmjs.org/package/const-smallest-float64

[build-image]: http://img.shields.io/travis/const-io/smallest-float64/master.svg
[build-url]: https://travis-ci.org/const-io/smallest-float64

[coverage-image]: https://img.shields.io/codecov/c/github/const-io/smallest-float64/master.svg
[coverage-url]: https://codecov.io/github/const-io/smallest-float64?branch=master

[dependencies-image]: http://img.shields.io/david/const-io/smallest-float64.svg
[dependencies-url]: https://david-dm.org/const-io/smallest-float64

[dev-dependencies-image]: http://img.shields.io/david/dev/const-io/smallest-float64.svg
[dev-dependencies-url]: https://david-dm.org/dev/const-io/smallest-float64

[github-issues-image]: http://img.shields.io/github/issues/const-io/smallest-float64.svg
[github-issues-url]: https://github.com/const-io/smallest-float64/issues

[tape]: https://github.com/substack/tape
[istanbul]: https://github.com/gotwarlost/istanbul
[testling]: https://ci.testling.com

[compute-io]: https://github.com/compute-io/
[ieee754]: http://en.wikipedia.org/wiki/IEEE_754-1985

Infinite
===
[![NPM version][npm-image]][npm-url] [![Build Status][build-image]][build-url] [![Coverage Status][coverage-image]][coverage-url] [![Dependencies][dependencies-image]][dependencies-url]

> Validates if a value is infinite.


## Installation

``` bash
$ npm install validate.io-infinite
```


## Usage

``` javascript
var isInfinite = require( 'validate.io-infinite' );
```

#### isInfinite( x )

Validates if a value is `infinite`.

``` javascript
var bool = isInfinite( Number.POSITIVE_INFINITY );
// returns true

bool = isInfinite( 1e308 );
// returns false
```


## Examples

``` javascript
var isInfinite = require( 'validate.io-infinite' );

console.log( isInfinite( Number.POSITIVE_INFINITY ) );
// returns true

console.log( isInfinite( Number.NEGATIVE_INFINITY ) );
// returns true

console.log( isInfinite( 0 ) );
// returns false

console.log( isInfinite( 1e308 ) );
// returns false

console.log( isInfinite( NaN ) );
// returns false

console.log( isInfinite( true ) );
// returns false

console.log( isInfinite( null ) );
// returns false

console.log( isInfinite( 'infinite' ) );
// returns false
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


[npm-image]: http://img.shields.io/npm/v/validate.io-infinite.svg
[npm-url]: https://npmjs.org/package/validate.io-infinite

[build-image]: http://img.shields.io/travis/validate-io/infinite/master.svg
[build-url]: https://travis-ci.org/validate-io/infinite

[coverage-image]: https://img.shields.io/codecov/c/github/validate-io/infinite/master.svg
[coverage-url]: https://codecov.io/github/validate-io/infinite?branch=master

[dependencies-image]: http://img.shields.io/david/validate-io/infinite.svg
[dependencies-url]: https://david-dm.org/validate-io/infinite

[dev-dependencies-image]: http://img.shields.io/david/dev/validate-io/infinite.svg
[dev-dependencies-url]: https://david-dm.org/dev/validate-io/infinite

[github-issues-image]: http://img.shields.io/github/issues/validate-io/infinite.svg
[github-issues-url]: https://github.com/validate-io/infinite/issues

[tape]: https://github.com/substack/tape
[istanbul]: https://github.com/gotwarlost/istanbul
[testling]: https://ci.testling.com

[compute-io]: https://github.com/compute-io

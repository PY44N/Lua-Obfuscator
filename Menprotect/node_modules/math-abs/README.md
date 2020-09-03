Absolute Value
===
[![NPM version][npm-image]][npm-url] [![Build Status][build-image]][build-url] [![Coverage Status][coverage-image]][coverage-url] [![Dependencies][dependencies-image]][dependencies-url]

> Computes an [absolute value][absolute-value].

The [absolute value][absolute-value] is defined as

<div class="equation" align="center" data-raw-text="|x| = \begin{cases} x &amp; \textrm{if}\ x \geq 0 \\ -x &amp; \textrm{if}\ x < 0\end{cases}" data-equation="eq:absolute_value">
	<img src="https://cdn.rawgit.com/math-io/abs/ea1d4096f7300f593d29705b025c1f7bf47da1b5/docs/img/eqn.svg" alt="Absolute value definition.">
	<br>
</div>


## Installation

``` bash
$ npm install math-abs
```


## Usage

``` javascript
var abs = require( 'math-abs' );
```

#### abs( x )

Computes an [absolute value][absolute-value].

``` javascript
var val = abs( -1 );
// returns 1

val = abs( 2 );
// returns 2

val = abs( 0 );
// returns 0

val = abs( -0 );
// returns 0
```


## Examples

``` javascript
var abs = require( 'math-abs' );

var rand;
var sign;
var i;
for ( i = 0; i < 100; i++ ) {
	rand = Math.round( Math.random() * 100 ) - 50;
	sign = Math.random();
	if ( sign < 0.5 ) {
		sign = -1;
	} else {
		sign = 1;
	}
	console.log( 'Before: %d. After: %d.', rand, abs( rand ) );
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


[npm-image]: http://img.shields.io/npm/v/math-abs.svg
[npm-url]: https://npmjs.org/package/math-abs

[build-image]: http://img.shields.io/travis/math-io/abs/master.svg
[build-url]: https://travis-ci.org/math-io/abs

[coverage-image]: https://img.shields.io/codecov/c/github/math-io/abs/master.svg
[coverage-url]: https://codecov.io/github/math-io/abs?branch=master

[dependencies-image]: http://img.shields.io/david/math-io/abs.svg
[dependencies-url]: https://david-dm.org/math-io/abs

[dev-dependencies-image]: http://img.shields.io/david/dev/math-io/abs.svg
[dev-dependencies-url]: https://david-dm.org/dev/math-io/abs

[github-issues-image]: http://img.shields.io/github/issues/math-io/abs.svg
[github-issues-url]: https://github.com/math-io/abs/issues

[tape]: https://github.com/substack/tape
[istanbul]: https://github.com/gotwarlost/istanbul
[testling]: https://ci.testling.com

[compute-io]: https://github.com/compute-io/
[absolute-value]: https://en.wikipedia.org/wiki/Absolute_value

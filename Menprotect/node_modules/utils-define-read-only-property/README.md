Read-Only
===
[![NPM version][npm-image]][npm-url] [![Build Status][build-image]][build-url] [![Coverage Status][coverage-image]][coverage-url] [![Dependencies][dependencies-image]][dependencies-url]

> [Defines][define-property] a __read-only__ property.


## Installation

``` bash
$ npm install utils-define-read-only-property
```


## Usage

``` javascript
var setReadOnly = require( 'utils-define-read-only-property' );
```

#### setReadOnly( obj, prop, value )

[Defines][define-property] a __read-only__ property.

``` javascript
var obj = {};
setReadOnly( obj, 'foo', 'bar' );
obj.foo = 'boop'; // => throws
```


## Examples

``` javascript
var setReadOnly = require( 'utils-define-read-only-property' );

class Foo {
	constructor( name ) {
		setReadOnly( this, 'name', name );
	}
}

var foo = new Foo( 'beep' );

try {
	foo.name = 'boop';
} catch ( err ) {
	console.error( err.message );
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

Copyright &copy; 2016. Athan Reines.


[npm-image]: http://img.shields.io/npm/v/utils-define-read-only-property.svg
[npm-url]: https://npmjs.org/package/utils-define-read-only-property

[build-image]: http://img.shields.io/travis/kgryte/utils-define-read-only-property/master.svg
[build-url]: https://travis-ci.org/kgryte/utils-define-read-only-property

[coverage-image]: https://img.shields.io/codecov/c/github/kgryte/utils-define-read-only-property/master.svg
[coverage-url]: https://codecov.io/github/kgryte/utils-define-read-only-property?branch=master

[dependencies-image]: http://img.shields.io/david/kgryte/utils-define-read-only-property.svg
[dependencies-url]: https://david-dm.org/kgryte/utils-define-read-only-property

[dev-dependencies-image]: http://img.shields.io/david/dev/kgryte/utils-define-read-only-property.svg
[dev-dependencies-url]: https://david-dm.org/dev/kgryte/utils-define-read-only-property

[github-issues-image]: http://img.shields.io/github/issues/kgryte/utils-define-read-only-property.svg
[github-issues-url]: https://github.com/kgryte/utils-define-read-only-property/issues

[tape]: https://github.com/substack/tape
[istanbul]: https://github.com/gotwarlost/istanbul
[testling]: https://ci.testling.com

[define-property]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty

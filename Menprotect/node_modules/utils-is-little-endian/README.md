Little Endian
===
[![NPM version][npm-image]][npm-url] [![Build Status][build-image]][build-url] [![Coverage Status][coverage-image]][coverage-url] [![Dependencies][dependencies-image]][dependencies-url]

> Check if an environment is [little endian][endianness].


## Installation

``` bash
$ npm install utils-is-little-endian
```


## Usage

``` javascript
var isLittleEndian = require( 'utils-is-little-endian' );
```

#### isLittleEndian

`Boolean` indicating if an environment is [little endian][endianness].

``` javascript
var bool = isLittleEndian;
// returns <boolean>
```


## Examples

``` javascript
var isLittleEndian = require( 'utils-is-little-endian' );

console.log( isLittleEndian );
// returns <boolean>
```

To run the example code from the top-level application directory,

``` bash
$ node ./examples/index.js
```


---
## CLI

### Installation

To use the module as a general utility, install the module globally

``` bash
$ npm install -g utils-is-little-endian
```


### Usage

``` bash
Usage: is-le [options]

Options:

  -h,    --help                Print this message.
  -V,    --version             Print the package version.
```


### Examples

``` bash
$ is-le
# => true | false
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


[npm-image]: http://img.shields.io/npm/v/utils-is-little-endian.svg
[npm-url]: https://npmjs.org/package/utils-is-little-endian

[build-image]: http://img.shields.io/travis/kgryte/utils-is-little-endian/master.svg
[build-url]: https://travis-ci.org/kgryte/utils-is-little-endian

[coverage-image]: https://img.shields.io/codecov/c/github/kgryte/utils-is-little-endian/master.svg
[coverage-url]: https://codecov.io/github/kgryte/utils-is-little-endian?branch=master

[dependencies-image]: http://img.shields.io/david/kgryte/utils-is-little-endian.svg
[dependencies-url]: https://david-dm.org/kgryte/utils-is-little-endian

[dev-dependencies-image]: http://img.shields.io/david/dev/kgryte/utils-is-little-endian.svg
[dev-dependencies-url]: https://david-dm.org/dev/kgryte/utils-is-little-endian

[github-issues-image]: http://img.shields.io/github/issues/kgryte/utils-is-little-endian.svg
[github-issues-url]: https://github.com/kgryte/utils-is-little-endian/issues

[tape]: https://github.com/substack/tape
[istanbul]: https://github.com/gotwarlost/istanbul
[testling]: https://ci.testling.com

[endianness]: http://en.wikipedia.org/wiki/Endianness

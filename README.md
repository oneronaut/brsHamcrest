# brsHamcrest
Hamcrest implementation in BrightScript


## Usage
brsHamcrest is designed for use standalone or with an existing unit test framework (such as [brstest](https://github.com/MarkRoddy/brstest)).


### Assertions
You can use either `assertThat()` or `that()` to assert that a Matcher returns positive:
```brightscript
assertThat(foo, is(aString()))
assertThat(foo, startsWithString("bar"))
assertThat(foo, is(allOf([aNumber(), greaterThan(5), lessThan(10)])))
```

You may find that using `that()` fits better with an assertion from an existing test framework:
```brightscript
assertTrue(that(foo, is(aString())))
assertTrue(that(foo, startsWithString("bar")))
assertTrue(that(foo, is(allOf([aNumber(), greaterThan(5.3), lessThan(10)]))))
```

For more information, see the [Assertions wiki page](https://github.com/imbenjamin/brsHamcrest/wiki/Assertions).

### Matcher Wrappers
You can wrap a Matcher (or several Matchers) in various wrappers:
```brightscript
' is() doesn't change logic, just improves readability:
assertThat(foo, is(aString()))

' isNot() inverses a Matcher's output:
assertThat(foo, isNot(aString()))

' allOf() / anyOf() / noneOf() checks against several Matchers:
assertThat(foo, is(allOf([aNumber(), lessThan(5)])))
assertThat(foo, is(anyOf([anArray(), anAssociativeArray()])))
assertThat(foo, is(noneOf([startsWithString("bar"), endsWithString("bar")])))
```
As you can see in the examples, you can chain up Wrappers to form an easy to read assertion. This can read to some different structures but equal outputs, for example `isNot(anyOf())` is equal to `is(noneOf())`, it's up to you.

For more information, see the [Core Matchers wiki page](https://github.com/imbenjamin/brsHamcrest/wiki/Core-Matchers).


### Matchers
Included are various Matchers, such as:
```brightscript
' Examples are listed here, this is not a complete list.

' Type Matchers
assertThat(10, is(anInteger()))
assertThat("foo", is(aString()))
assertThat(myFunc, is(aFunction()))

' Numeric Matchers
assertThat(10, is(greaterThan(5)))
assertThat(3.543, is(lessThanOrEqualTo(8.5)))
assertThat(5.5, is(closeTo(5, 0.8)))

' Text Matchers
assertThat("foobar", startsWithString("foo"))
assertThat("foobar", endsWithString("bar"))
assertThat("foobar", containsStringsInOrder(["foo", "bar"]))

' Collection Matchers
assertThat(myArray, is(anEmptyCollection()))
assertThat("foo", is(inCollection(["foo", "bar"])))
assertThat(myAssocArray, containsKeyValuePairs({foo: "bar", someKey: "someValue"}))
```

Feel free to create your own Matchers, just extend from `BaseMatcher` and ensure that the `doMatch()` function returns a `Boolean`.

For more information, see the [Matcher pages available on the wiki](https://github.com/imbenjamin/brsHamcrest/wiki).

## Unit Tests
brsHamcrest is fully unit tested. the `tests` directory contains the unit test source files and testrunner utility (using [brstestrunner](https://github.com/sky-uk/roku-brstestrunner)). To run the unit tests, execute `make test` from the project directory (where `Makefile` is located).

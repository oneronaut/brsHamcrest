# brsHamcrest
Hamcrest implementation in BrightScript

## Usage
brsHamcrest is designed for use standalone or with an existing unit test framework (such as [brstest](https://github.com/MarkRoddy/brstest)).

### Assertions
You can use either `assertThat()` or `that()` to assert that a Matcher returns positive:
```brightscript
assertThat(foo, is(aString()))
assertThat(foo, startsWithString("bar"))
assertThat(foo, is(allOf(aNumber(), greaterThan(5), lessThan(10))))
```

You may find that using `that()` fits better with an assertion from an existing test framework:
```brightscript
assertTrue(that(foo, is(aString())))
assertTrue(that(foo, startsWithString("bar")))
assertTrue(that(foo, is(allOf([aNumber(), greaterThan(5.3), lessThan(10)]))))
```

### Matchers
Included are various Matchers, such as:
```brightscript
' Examples are listed here, this is not a complete list.

' Type Matchers
assertThat(10, is(anInteger))
assertThat("foo", is(aString))
assertThat(myFunc, is(aFunction))

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
assertThat(myAssocArray, containsKeyValuePairs([{foo: "bar"}, {someKey: "someValue"}]))
```

Feel free to create your own Matchers, just extend from `BaseMatcher` and ensure that the `doMatch()` function returns a `Boolean`.
' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


' SETUP / TEARDOWN

'Set up the unit tests
'
'@return {Object} The test helper
function setup_brsHamcrest_CoreMatchers () as Object
    test = {
        knownString: "knownString"
    }
    return test
end function

'Clean up after running a unit test
function teardown_brsHamcrest_CoreMatchers () as Void

end function

' UNIT TESTS

' is()
sub test_is_matcherTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    matcher = FakeBaseMatcher()
    matcher.willMatch = true

    'WHEN'
    result = is(matcher).doMatch()

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_is_matcherFalse (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    matcher = FakeBaseMatcher()
    matcher.willMatch = false

    'WHEN'
    result = is(matcher).doMatch()

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_is_arrayTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    dummyTarget = {}
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = true
    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = true
    matcherArray = [matcher1, matcher2]

    'WHEN'
    result = is(matcherArray).doMatch(dummyTarget)

    t.assertTrue(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_is_arraySomeTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    dummyTarget = {}
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = true
    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = false
    matcherArray = [matcher1, matcher2]

    'WHEN'
    result = is(matcherArray).doMatch(dummyTarget)

    t.assertFalse(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_is_arrayNoneTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    dummyTarget = {}
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = false
    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = false
    matcherArray = [matcher1, matcher2]

    'WHEN'
    result = is(matcherArray).doMatch(dummyTarget)

    t.assertFalse(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


'isNot()
sub test_isNot_matcherTrueResultFalse (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    matcher = FakeBaseMatcher()
    matcher.willMatch = true

    'WHEN'
    result = isNot(matcher).doMatch(test.knownString)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_isNot_matcherFalseResultTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    matcher = FakeBaseMatcher()
    matcher.willMatch = false

    'WHEN'
    result = isNot(matcher).doMatch(test.knownString)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_isNot_arrayTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    dummyTarget = {}
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = true
    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = true
    matcherArray = [matcher1, matcher2]

    'WHEN'
    result = isNot(matcherArray).doMatch(dummyTarget)

    t.assertFalse(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_isNot_arraySomeTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    dummyTarget = {}
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = true
    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = false
    matcherArray = [matcher1, matcher2]

    'WHEN'
    result = isNot(matcherArray).doMatch(dummyTarget)

    t.assertFalse(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_isNot_arrayNoneTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    dummyTarget = {}
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = false
    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = false
    matcherArray = [matcher1, matcher2]

    'WHEN'
    result = isNot(matcherArray).doMatch(dummyTarget)

    t.assertTrue(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


'anything()
sub test_anything (t as Object)
    setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    knownTarget = {}

    'WHEN'
    result = anything().doMatch(knownTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


'allOf()
sub test_allOf_allMatchersTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = true

    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = true

    matcher3 = FakeBaseMatcher()
    matcher3.willMatch = true

    'WHEN'
    result = allOf([matcher1, matcher2, matcher3]).doMatch(test.knownString)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_allOf_someMatchersTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = true

    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = true

    matcher3 = FakeBaseMatcher()
    matcher3.willMatch = false

    'WHEN'
    result = allOf([matcher1, matcher2, matcher3]).doMatch(test.knownString)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_allOf_noMatchersTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = false

    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = false

    matcher3 = FakeBaseMatcher()
    matcher3.willMatch = false

    'WHEN'
    result = allOf([matcher1, matcher2, matcher3]).doMatch(test.knownString)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


'anyOf()
sub test_anyOf_allMatchersTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = true

    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = true

    matcher3 = FakeBaseMatcher()
    matcher3.willMatch = true

    'WHEN'
    result = anyOf([matcher1, matcher2, matcher3]).doMatch(test.knownString)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_anyOf_someMatchersTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = true

    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = true

    matcher3 = FakeBaseMatcher()
    matcher3.willMatch = false

    'WHEN'
    result = anyOf([matcher1, matcher2, matcher3]).doMatch(test.knownString)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_anyOf_noMatchersTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = false

    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = false

    matcher3 = FakeBaseMatcher()
    matcher3.willMatch = false

    'WHEN'
    result = anyOf([matcher1, matcher2, matcher3]).doMatch(test.knownString)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


'noneOf()
sub test_noneOf_allMatchersTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = true

    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = true

    matcher3 = FakeBaseMatcher()
    matcher3.willMatch = true

    'WHEN'
    result = noneOf([matcher1, matcher2, matcher3]).doMatch(test.knownString)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_noneOf_someMatchersTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = true

    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = true

    matcher3 = FakeBaseMatcher()
    matcher3.willMatch = false

    'WHEN'
    result = noneOf([matcher1, matcher2, matcher3]).doMatch(test.knownString)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_noneOf_noMatchersTrue (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'GIVEN'
    matcher1 = FakeBaseMatcher()
    matcher1.willMatch = false

    matcher2 = FakeBaseMatcher()
    matcher2.willMatch = false

    matcher3 = FakeBaseMatcher()
    matcher3.willMatch = false

    'WHEN'
    result = noneOf([matcher1, matcher2, matcher3]).doMatch(test.knownString)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


'equalTo()

sub test_equalTo_matchesIdenticalValues (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'WHEN'
    result = equalTo(test.knownString).doMatch(test.knownString)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_equalTo_doesNotMatchDifferentValues (t as Object)
    test = setup_brsHamcrest_CoreMatchers()

    'WHEN'
    result = equalTo(true).doMatch(false)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CoreMatchers()
end sub


sub test_equalTo_withIdenticalDataTypes (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownString: "knownStringParam"
            knownInteger: 1
            knownBoolean: true
            knownFloat: 1/3
            knownDouble: 2.3#
            knownLongInteger: 987654321&
        }
    end function
    'WHEN'
    result = equalTo(getFooObj()).doMatch(getFooObj())
    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_equalTo_withDifferentDataTypes (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownString: "knownString"
            knownInteger: 1
            knownBoolean: true
        }
    end function

    getDifferentFooObj = function () as Object
        return {
            knownString: "knownString"
            differentString: "differentString"
            knownInteger: 1
            knownBoolean: true
        }
    end function
    'WHEN'
    result = equalTo(getDifferentFooObj()).doMatch(getFooObj())
    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_equalTo_withSameKeysDifferentValues (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownString: "knownString1"
            knownInteger: 1
            knownBoolean: true
        }
    end function

    getDifferentFooObj = function () as Object
        return {
            knownString: "knownString2"
            knownInteger: 2
            knownBoolean: false
        }
    end function
    'WHEN'
    result = equalTo(getDifferentFooObj()).doMatch(getFooObj())
    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_equalTo_withInvalidValues (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownInvalid: Invalid
        }
    end function

    'WHEN'
    result = equalTo(getFooObj()).doMatch(getFooObj())
    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_equalTo_withIdenticalAPI (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownFunction1: function ()
            end function
            knownFunction2: function ()
            end function
            knownFunction3: function ()
            end function
        }
    end function
    'WHEN'
    result = equalTo(getFooObj()).doMatch(getFooObj())
    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_equalTo_withDifferentAPI (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownFunction1: function ()
            end function
            knownFunction2: function ()
            end function
            knownFunction3: function ()
            end function
        }
    end function
    target = getFooObj()
    comparison = getFooObj()
    comparison.additionalFunction = function ()
    end function
    'WHEN'
    result = equalTo(comparison).doMatch(target)
    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_equalTo_withIdenticalCollectionDataTypes (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownArray: ["foo", "bar"]
            knownAssocArray: {
                foo: "bar"
                flag: true
            }
        }
    end function
    'WHEN'
    result = equalTo(getFooObj()).doMatch(getFooObj())
    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_equalTo_withdifferentCollectionData (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownArray: ["foo", "bar"]
            knownAssocArray: {
                foo: "bar"
                flag: true
            }
        }
    end function
    target = getFooObj()
    comparison = getFooObj()
    comparison.knownArray = ["foo", "bar", "two"]
    'WHEN'
    result = equalTo(comparison).doMatch(target)
    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_equalTo_withNonStrictTypeMatching (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    target = {
        propString: "foo"
        propBoolean: true
        propInteger: 2
        propNumber:  1.2345
    }
    'XXX: Parsing the object as a json string will create non-strict types (e.g. "String"
    '     instead of "roString"). But these properties should still actually match.
    comparison = ParseJson("{""propString"": ""foo"",""propBoolean"": true,""propInteger"": 2,""propNumber"": 1.2345}")
    'WHEN'
    result = equalTo(comparison).doMatch(target)
    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_equalTo_withItemsApiMethodOverwritten (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    getFooObj = function () as Object
        return {
            items: ["item1","item2","item3"]
            knownString: "knownStringParam"
            knownInteger: 1
            knownBoolean: true
            knownFloat: 1/3
            knownDouble: 2.3#
            knownLongInteger: 987654321&
        }
    end function
    'WHEN'
    result = equalTo(getFooObj()).doMatch(getFooObj())
    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_equalTo_targetAndValueAreIdenticalObjects_withDifferentKeyOrder (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = {
        lorem: false
        ipsum: "dolor sit amet"
        consectetur: "adipiscing elit"
        sed: "do"
        eiusmod: "tempor"
        incididunt: 0
        ut: "labore et dolore"
        magna : "aliqua"
        enim: "ad minim veniam"
        quis: 20.99
        nostrud: "exercitation ullamco laboris"
        nisi: false
        aliquip: "ex ea commodo"
        consequat: "Duis aute irure dolor"
        reprehenderit: "in voluptate velit esse "
        cillum: "dolore eu fugiat nulla"
        pariatur: true
    }

    testValue = {
        consectetur: "adipiscing elit"
        lorem: false
        pariatur: true
        sed: "do"
        cillum: "dolore eu fugiat nulla"
        eiusmod: "tempor"
        nostrud: "exercitation ullamco laboris"
        reprehenderit: "in voluptate velit esse "
        ut: "labore et dolore"
        consequat: "Duis aute irure dolor"
        magna : "aliqua"
        aliquip: "ex ea commodo"
        nisi: false
        ipsum: "dolor sit amet"
        enim: "ad minim veniam"
        quis: 20.99
        incididunt: 0
    }

    'WHEN'
    result = equalTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_ObjectMatchers()
end sub

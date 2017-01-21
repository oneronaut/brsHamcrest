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

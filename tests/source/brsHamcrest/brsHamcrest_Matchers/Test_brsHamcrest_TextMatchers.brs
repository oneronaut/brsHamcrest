' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


' SETUP / TEARDOWN

'Set up the unit tests
'
'@return {Object} The test helper
function setup_brsHamcrest_TextMatchers () as Object
    test = {
        knownString: "knownString"
    }
    return test
end function

'Clean up after running a unit test
function teardown_brsHamcrest_TextMatchers () as Void

end function

' UNIT TESTS

' containsString()
sub test_containsString_true (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = test.knownString
    testToMatch = "now"

    'WHEN'
    result = containsString(testToMatch).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_containsString_false (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = test.knownString
    testToMatch = "foo"

    'WHEN'
    result = containsString(testToMatch).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_containsString_targetIsIncorrectType (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = false
    testToMatch = "foo"

    'WHEN'
    result = containsString(testToMatch).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_TextMatchers()
end sub


'containsStrings()
sub test_containsStrings_allStringsPresent (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = test.knownString
    testStringsArray = ["kno", "wnS", "tri", "ng"]

    'WHEN'
    result = containsStrings(testStringsArray).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_containsStrings_someStringsPresent (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = test.knownString
    testStringsArray = ["kno", "wnS", "tri"]

    'WHEN'
    result = containsStrings(testStringsArray).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_containsStrings_noStringsPresent (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = test.knownString
    testStringsArray = ["foo", "bar"]

    'WHEN'
    result = containsStrings(testStringsArray).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_containsStrings_targetIsIncorrectType (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = false
    testStringsArray = ["foo", "bar"]

    'WHEN'
    result = containsStrings(testStringsArray).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_TextMatchers()
end sub


'containsStringsInOrder()
sub test_containsStringsInOrder_allStringsInOrder (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = test.knownString
    testStringsArray = ["kno", "wnS", "tri", "ng"]

    'WHEN'
    result = containsStringsInOrder(testStringsArray).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_containsStringsInOrder_someStringsInOrder (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = test.knownString
    testStringsArray = ["kno", "wnS", "tri"]

    'WHEN'
    result = containsStringsInOrder(testStringsArray).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_containsStringsInOrder_allStringsIncorrectOrder (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = test.knownString
    testStringsArray = ["kno", "wnS", "ng", "tri"]

    'WHEN'
    result = containsStringsInOrder(testStringsArray).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_containsStringsInOrder_targetIsIncorrectType (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = false
    testStringsArray = ["kno", "wnS", "ng", "tri"]

    'WHEN'
    result = containsStringsInOrder(testStringsArray).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_TextMatchers()
end sub


'startsWithString()
sub test_startsWithString_true (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = test.knownString
    testStartString = "known"

    'WHEN'
    result = startsWithString(testStartString).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_startsWithString_false (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = test.knownString
    testStartString = "foo"

    'WHEN'
    result = startsWithString(testStartString).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_startsWithString_targetIsIncorrectType (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = false
    testStartString = "foo"

    'WHEN'
    result = startsWithString(testStartString).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_TextMatchers()
end sub


'endsWithString()
sub test_endsWithString_true (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = test.knownString
    testEndString = "String"

    'WHEN'
    result = endsWithString(testEndString).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_endsWithString_false (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = test.knownString
    testEndString = "foo"

    'WHEN'
    result = endsWithString(testEndString).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_endsWithString_targetIsIncorrectType (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testTarget = false
    testEndString = "foo"

    'WHEN'
    result = endsWithString(testEndString).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_TextMatchers()
end sub


'anEmptyString()
sub test_anEmptyString_noCharsTrue (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testString = ""

    'WHEN'
    result = anEmptyString().doMatch(testString)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_anEmptyString_whitespaceCharsTrue (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testString = "      "

    'WHEN'
    result = anEmptyString().doMatch(testString)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_anEmptyString_false (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testString = test.knownString

    'WHEN'
    result = anEmptyString().doMatch(testString)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_TextMatchers()
end sub


sub test_anEmptyString_targetIsIncorrectType (t as Object)
    test = setup_brsHamcrest_TextMatchers()

    'GIVEN'
    testString = false

    'WHEN'
    result = anEmptyString().doMatch(testString)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_TextMatchers()
end sub

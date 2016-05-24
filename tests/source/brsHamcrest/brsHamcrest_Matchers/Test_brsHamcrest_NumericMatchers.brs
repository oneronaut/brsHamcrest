' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################
'                 Copyright (c) 2016 Benjamin Hill

' SETUP / TEARDOWN

'Set up the unit tests
'
'@return {Object} The test helper
function setup_brsHamcrest_NumericMatchers () as Object
    test = {
        knownBigInt: 15%
        knownBigFloat: 15.8!

        knownSmallInt: 4%
        knownSmallFloat: 7.3!

        knownTinyInt: 1%
        knownTinyFloat: 0.4!
    }
    return test
end function

'Clean up after running a unit test
function teardown_brsHamcrest_NumericMatchers () as Void

end function

' UNIT TESTS

' closeTo()
sub test_closeTo_ValuesAsIntTrue (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownSmallInt
    testValue = test.knownTinyInt
    testDelta = test.knownBigInt

    'WHEN'
    result = closeTo(testValue, testDelta).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_closeTo_ValuesAsFloatTrue (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownSmallFloat
    testValue = test.knownTinyFloat
    testDelta = test.knownBigFloat

    'WHEN'
    result = closeTo(testValue, testDelta).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_closeTo_MixedNumbersTrue (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownSmallInt
    testValue = test.knownSmallFloat
    testDelta = test.knownBigInt

    'WHEN'
    result = closeTo(testValue, testDelta).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_closeTo_ValuesAsIntFalse (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownBigInt
    testValue = test.knownSmallInt
    testDelta = test.knownTinyInt

    'WHEN'
    result = closeTo(testValue, testDelta).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_closeTo_ValuesAsFloatFalse (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownBigFloat
    testValue = test.knownSmallFloat
    testDelta = test.knownTinyFloat

    'WHEN'
    result = closeTo(testValue, testDelta).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_closeTo_MixedNumbersFalse (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownBigInt
    testValue = test.knownSmallFloat
    testDelta = test.knownTinyInt

    'WHEN'
    result = closeTo(testValue, testDelta).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


'greaterThan()
sub test_greaterThan_valueAsIntTrue (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownBigInt
    testValue = test.knownSmallInt

    'WHEN'
    result = greaterThan(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_greaterThan_valueAsFloatTrue (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownBigFloat
    testValue = test.knownSmallFloat

    'WHEN'
    result = greaterThan(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_greaterThan_valueAsIntFalse (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownSmallInt
    testValue = test.knownBigInt

    'WHEN'
    result = greaterThan(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_greaterThan_valueAsFloatFalse (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownSmallFloat
    testValue = test.knownBigFloat

    'WHEN'
    result = greaterThan(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


'greaterThanOrEqualTo()

'lessThan()

'lessThanOrEqualTo()

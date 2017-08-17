' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


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
sub test_closeTo_IntCloseToInt (t as Object)
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


sub test_closeTo_FloatCloseToFloat (t as Object)
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


sub test_closeTo_IntCloseToFloat (t as Object)
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


sub test_closeTo_IntNotCloseToInt (t as Object)
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


sub test_closeTo_FloatNotCloseToFloat (t as Object)
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


sub test_closeTo_IntNotCloseFloat (t as Object)
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


sub test_closeTo_targetIsIncorrectType (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = "foo"
    testValue = test.knownSmallFloat
    testDelta = test.knownTinyInt

    'WHEN'
    result = closeTo(testValue, testDelta).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


'greaterThan()
sub test_greaterThan_IntGreaterThanInt (t as Object)
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


sub test_greaterThan_FloatGreaterThanFloat (t as Object)
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


sub test_greaterThan_IntSmallerThanInt (t as Object)
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


sub test_greaterThan_FloatSmallerThanFloat (t as Object)
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


sub test_greaterThan_targetIsIncorrectType (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = "foo"
    testValue = test.knownSmallFloat

    'WHEN'
    result = greaterThan(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


'greaterThanOrEqualTo()
sub test_greaterThanOrEqualTo_IntGreaterThanInt (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownBigInt
    testValue = test.knownSmallInt

    'WHEN'
    result = greaterThanOrEqualTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_greaterThanOrEqualTo_FloatGreaterThanFloat (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownBigFloat
    testValue = test.knownSmallFloat

    'WHEN'
    result = greaterThanOrEqualTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_greaterThanOrEqualTo_IntEqualToInt (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownBigInt
    testValue = test.knownBigInt

    'WHEN'
    result = greaterThanOrEqualTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_greaterThanOrEqualTo_FloatEqualToFloat (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownBigFloat
    testValue = test.knownSmallFloat

    'WHEN'
    result = greaterThanOrEqualTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_greaterThanOrEqualTo_IntLessThanInt (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownSmallInt
    testValue = test.knownBigInt

    'WHEN'
    result = greaterThanOrEqualTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_greaterThanOrEqualTo_FloatLessThanFloat (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownSmallFloat
    testValue = test.knownBigFloat

    'WHEN'
    result = greaterThanOrEqualTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_greaterThanOrEqualTo_targetIsIncorrectType (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = "foo"
    testValue = test.knownBigFloat

    'WHEN'
    result = greaterThanOrEqualTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


'lessThan()
sub test_lessThan_IntGreaterThanInt (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownBigInt
    testValue = test.knownSmallInt

    'WHEN'
    result = lessThan(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_lessThan_FloatGreaterThanFloat (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownBigFloat
    testValue = test.knownSmallFloat

    'WHEN'
    result = lessThan(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_lessThan_IntSmallerThanInt (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownSmallInt
    testValue = test.knownBigInt

    'WHEN'
    result = lessThan(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_lessThan_FloatSmallerThanFloat (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownSmallFloat
    testValue = test.knownBigFloat

    'WHEN'
    result = lessThan(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_lessThan_targetIsIncorrectType (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = "foo"
    testValue = test.knownBigFloat

    'WHEN'
    result = lessThan(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


'lessThanOrEqualTo()
sub test_lessThanOrEqualTo_IntGreaterThanInt (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownBigInt
    testValue = test.knownSmallInt

    'WHEN'
    result = lessThanOrEqualTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_lessThanOrEqualTo_FloatGreaterThanFloat (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownBigFloat
    testValue = test.knownSmallFloat

    'WHEN'
    result = lessThanOrEqualTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_lessThanOrEqualTo_IntEqualToInt (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownBigInt
    testValue = test.knownBigInt

    'WHEN'
    result = lessThanOrEqualTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_lessThanOrEqualTo_FloatEqualToFloat (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownSmallFloat
    testValue = test.knownBigFloat

    'WHEN'
    result = lessThanOrEqualTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_lessThanOrEqualTo_IntLessThanInt (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownSmallInt
    testValue = test.knownBigInt

    'WHEN'
    result = lessThanOrEqualTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_lessThanOrEqualTo_FloatLessThanFloat (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = test.knownSmallFloat
    testValue = test.knownBigFloat

    'WHEN'
    result = lessThanOrEqualTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_NumericMatchers()
end sub


sub test_lessThanOrEqualTo_isIncorrectType (t as Object)
    test = setup_brsHamcrest_NumericMatchers()

    'GIVEN'
    testTarget = "foo"
    testValue = test.knownBigFloat

    'WHEN'
    result = lessThanOrEqualTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_NumericMatchers()
end sub

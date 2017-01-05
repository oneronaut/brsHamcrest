' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


' SETUP / TEARDOWN

'Set up the unit tests
'
'@return {Object} The test helper
function setup_brsHamcrest_ObjectMatchers () as Object
    test = {
    }
    return test
end function

'Clean up after running a unit test
function teardown_brsHamcrest_ObjectMatchers () as Void

end function

' UNIT TESTS

' sameObjectAs()
sub test_sameObjectAs_sharedInstance (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = {foo: "bar"}
    testValue = testTarget

    'WHEN'
    result = sameObjectAs(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_ObjectMatchers()
end sub


sub test_sameObjectAs_differentInstances (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = {foo: "bar"}
    testValue = {bar: "foo"}

    'WHEN'
    result = sameObjectAs(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_ObjectMatchers()
end sub


sub test_sameObjectAs_targetIsNotObject (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = "foo"
    testValue = {foo: "bar"}

    'WHEN'
    result = sameObjectAs(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_ObjectMatchers()
end sub


sub test_sameObjectAs_valueIsNotObject (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = {foo: "bar"}
    testValue = "foo"

    'WHEN'
    result = sameObjectAs(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_ObjectMatchers()
end sub


sub test_sameObjectAs_targetAndValueAreNotObjects (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = 123
    testValue = "foo"

    'WHEN'
    result = sameObjectAs(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_ObjectMatchers()
end sub

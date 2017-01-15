' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


' SETUP / TEARDOWN

'Set up the unit tests
'
'@return {Object} The test helper
function setup_brsHamcrest_Matcher () as Object
    test = {
        brsHamcrestOptions: HamcrestOptions()
        knownString: "foo"
    }
    return test
end function

'Clean up after running a unit test
function teardown_brsHamcrest_Matcher () as Void

end function

' UNIT TESTS

' BaseMatcher()
sub test_BaseMatcher_defaultFalse (t as Object)
    test = setup_brsHamcrest_Matcher()

    'GIVEN'
    testBaseMatcher = BaseMatcher()
    testTarget = test.knownString
    test.brsHamcrestOptions.errors.suppressErrors = true

    'WHEN'
    result = testBaseMatcher.doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Matcher()
end sub

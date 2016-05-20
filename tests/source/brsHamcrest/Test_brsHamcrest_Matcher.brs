' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################
'                 Copyright (c) 2016 Benjamin Hill

' SETUP / TEARDOWN

'Set up the unit tests
'
'@return {Object} The test helper
function setup_brsHamcrest_Matcher () as Object
    test = {
        knownArray: []
        knownString: "foo"
        ifEnum: "ifEnum"
        unknownInterface: "ifFoo"
    }
    return test
end function

'Clean up after running a unit test
function teardown_brsHamcrest_Matcher () as Void

end function

' UNIT TESTS

' BaseMatcher()
sub test_BaseMatcher_defaultTrue (t as Object)
    test = setup_brsHamcrest_Matcher()

    'GIVEN'
    testBaseMatcher = BaseMatcher()
    testTarget = test.knownString

    'WHEN'
    result = testBaseMatcher.doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Matcher()
end sub


sub test_BaseMatcher_defaultTrue (t as Object)
    test = setup_brsHamcrest_Matcher()

    'GIVEN'
    testBaseMatcher = BaseMatcher()
    testTarget = test.knownString

    'WHEN'
    result = testBaseMatcher.doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Matcher()
end sub

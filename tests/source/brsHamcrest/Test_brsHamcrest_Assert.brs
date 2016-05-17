' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################
'                 Copyright (c) 2016 Benjamin Hill

' SETUP / TEARDOWN

'Set up the unit tests
'
'@return {Object} The test helper
function setup_brsHamcrest_Assert () as Object
    test = {
        knownString: "knownString"
    }
    return test
end function

'Clean up after running a unit test
function teardown_brsHamcrest_Assert () as Void

end function

' UNIT TESTS

' that()
sub test_that_matcherTrue (t as Object)
    test = setup_brsHamcrest_Assert()

    'GIVEN'
    testtarget = test.knownString
    testmatcher = FakeBaseMatcher()
    testmatcher.willMatch = true

    'WHEN'
    result = that(testtarget, testmatcher)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Assert()
end sub


sub test_that_matcherFalse (t as Object)
    test = setup_brsHamcrest_Assert()

    'GIVEN'
    testtarget = test.knownString
    testmatcher = FakeBaseMatcher()
    testmatcher.willMatch = false

    'WHEN'
    result = that(testtarget, testmatcher)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Assert()
end sub


' assertThat()
sub test_assertThat_matcherTrue (t as Object)
    test = setup_brsHamcrest_Assert()

    'GIVEN'
    testtarget = test.knownString
    testmatcher = FakeBaseMatcher()
    testmatcher.willMatch = true

    'WHEN'
    result = assertThat(testtarget, testmatcher)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Assert()
end sub


sub test_assertThat_matcherFalse (t as Object)
    test = setup_brsHamcrest_Assert()

    'GIVEN'
    testtarget = test.knownString
    testmatcher = FakeBaseMatcher()
    testmatcher.willMatch = false

    'WHEN'
    result = assertThat(testtarget, testmatcher)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Assert()
end sub

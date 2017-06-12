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
sub test_BaseMatcher_doMatchDefaultsToFalse (t as Object)
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


sub test_BaseMatcher_isSameMatch_identicalMatchers (t as Object)
    test = setup_brsHamcrest_Matcher()

    'GIVEN'
    target = BaseMatcher()
    comparison = BaseMatcher()

    'WHEN'
    result = target.isSameMatch(comparison)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Matcher()
end sub


sub test_BaseMatcher_isSameMatch_differentMatchers (t as Object)
    test = setup_brsHamcrest_Matcher()

    'GIVEN'
    target = BaseMatcher()
    target.append({
        foo: "foo"
        two: 2
        flag: true
    })
    comparison = BaseMatcher()
    comparison.append({
        foo: "foo"
        two: 2
        flag: false
    })

    'WHEN'
    result = target.isSameMatch(comparison)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Matcher()
end sub

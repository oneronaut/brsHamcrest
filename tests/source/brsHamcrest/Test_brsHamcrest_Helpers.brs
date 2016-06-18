' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################
'                 Copyright (c) 2016 Benjamin Hill

' SETUP / TEARDOWN

'Set up the unit tests
'
'@return {Object} The test helper
function setup_brsHamcrest_Helpers () as Object
    test = {
        knownArray: []
        knownString: "foo"
        ifEnum: "ifEnum"
        unknownInterface: "ifFoo"
    }
    return test
end function

'Clean up after running a unit test
function teardown_brsHamcrest_Helpers () as Void

end function

' UNIT TESTS

' HasInterface()
sub test_HasInterface_true (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    testObj = test.knownArray
    testInterface = test.ifEnum

    'WHEN'
    result = HasInterface(testObj, testInterface)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_HasInterface_false (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    testObj = test.knownString
    testInterface = test.ifEnum

    'WHEN'
    result = HasInterface(testObj, testInterface)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_HasInterface_false_unknownInterface (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    testObj = test.knownString
    testInterface = test.unknownInterface

    'WHEN'
    result = HasInterface(testObj, testInterface)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub

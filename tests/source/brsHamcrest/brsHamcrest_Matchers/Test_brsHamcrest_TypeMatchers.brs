' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


' SETUP / TEARDOWN

'Set up the unit tests
'
'@return {Object} The test helper
function setup_brsHamcrest_TypeMatchers () as Object
    test = {}
    'Known Intrinsic Types
    'A note about Doubles:
    '    It seems there's a BrightScript bug where a Double passed through a
    '    variable morphs it into a Float. Therefore tests pass their own known
    '    Double value (as '42#')
    test.knownBoolean = True
    test.knownFloat = 42.424242!
    test.knownFunction = function () as Void
    end function
    test.knownInteger = 42%
    test.knownInvalid = Invalid
    test.knownLongInteger = 42&
    test.knownString = "knownString"

    'Known Object Types
    test.knownRoArray = CreateObject("roArray", 0, false)
    test.knownRoAssociativeArray = CreateObject("roAssociativeArray")
    test.knownRoBoolean = CreateObject("roBoolean")
    test.knownRoDouble = CreateObject("roDouble")
    test.knownRoFloat = CreateObject("roFloat")
    test.knownRoFunction = CreateObject("roFunction")
    test.knownRoInt = CreateObject("roInt")
    test.knownRoInvalid = CreateObject("roInvalid")
    test.knownRoLongInteger = CreateObject("roLongInteger")
    test.knownRoString = CreateObject("roString")

    return test
end function

'Clean up after running a unit test
function teardown_brsHamcrest_TypeMatchers () as Void

end function

' UNIT TESTS

' aArray() / anArray()
sub test_aArray (t as Object)
    test = setup_brsHamcrest_TypeMatchers()

    'GIVEN'
    doAssert = function (testValue as Dynamic) as Boolean
        return (aArray().doMatch(testValue) AND anArray().doMatch(testValue))
    end function

    'WHEN'

    'THEN'
    t.assertFalse(doAssert(test.knownBoolean))
    t.assertFalse(doAssert(42#))
    t.assertFalse(doAssert(test.knownFloat))
    t.assertFalse(doAssert(test.knownFunction))
    t.assertFalse(doAssert(test.knownInteger))
    t.assertFalse(doAssert(test.knownInvalid))
    t.assertFalse(doAssert(test.knownLongInteger))
    t.assertFalse(doAssert(test.knownString))

    t.assertTrue(doAssert(test.knownRoArray))
    t.assertFalse(doAssert(test.knownRoAssociativeArray))
    t.assertFalse(doAssert(test.knownRoBoolean))
    t.assertFalse(doAssert(test.knownRoDouble))
    t.assertFalse(doAssert(test.knownRoFloat))
    t.assertFalse(doAssert(test.knownRoFunction))
    t.assertFalse(doAssert(test.knownRoInt))
    t.assertFalse(doAssert(test.knownRoInvalid))
    t.assertFalse(doAssert(test.knownRoLongInteger))
    t.assertFalse(doAssert(test.knownRoString))

    teardown_brsHamcrest_TypeMatchers()
end sub


' aAssociativeArray() / anAssociativeArray()
sub test_aAssociativeArray (t as Object)
    test = setup_brsHamcrest_TypeMatchers()

    'GIVEN'
    doAssert = function (testValue as Dynamic) as Boolean
        return (aAssociativeArray().doMatch(testValue) AND anAssociativeArray().doMatch(testValue))
    end function

    'WHEN'

    'THEN'
    t.assertFalse(doAssert(test.knownBoolean))
    t.assertFalse(doAssert(42#))
    t.assertFalse(doAssert(test.knownFloat))
    t.assertFalse(doAssert(test.knownFunction))
    t.assertFalse(doAssert(test.knownInteger))
    t.assertFalse(doAssert(test.knownInvalid))
    t.assertFalse(doAssert(test.knownLongInteger))
    t.assertFalse(doAssert(test.knownString))

    t.assertFalse(doAssert(test.knownRoArray))
    t.assertTrue(doAssert(test.knownRoAssociativeArray))
    t.assertFalse(doAssert(test.knownRoBoolean))
    t.assertFalse(doAssert(test.knownRoDouble))
    t.assertFalse(doAssert(test.knownRoFloat))
    t.assertFalse(doAssert(test.knownRoFunction))
    t.assertFalse(doAssert(test.knownRoInt))
    t.assertFalse(doAssert(test.knownRoInvalid))
    t.assertFalse(doAssert(test.knownRoLongInteger))
    t.assertFalse(doAssert(test.knownRoString))

    teardown_brsHamcrest_TypeMatchers()
end sub


' aBoolean()
sub test_aBoolean (t as Object)
    test = setup_brsHamcrest_TypeMatchers()

    'GIVEN'
    doAssert = function (testValue as Dynamic) as Boolean
        return (aBoolean().doMatch(testValue))
    end function

    'WHEN'

    'THEN'
    t.assertTrue(doAssert(test.knownBoolean))
    t.assertFalse(doAssert(42#))
    t.assertFalse(doAssert(test.knownFloat))
    t.assertFalse(doAssert(test.knownFunction))
    t.assertFalse(doAssert(test.knownInteger))
    t.assertFalse(doAssert(test.knownInvalid))
    t.assertFalse(doAssert(test.knownLongInteger))
    t.assertFalse(doAssert(test.knownString))

    t.assertFalse(doAssert(test.knownRoArray))
    t.assertFalse(doAssert(test.knownRoAssociativeArray))
    t.assertTrue(doAssert(test.knownRoBoolean))
    t.assertFalse(doAssert(test.knownRoDouble))
    t.assertFalse(doAssert(test.knownRoFloat))
    t.assertFalse(doAssert(test.knownRoFunction))
    t.assertFalse(doAssert(test.knownRoInt))
    t.assertFalse(doAssert(test.knownRoInvalid))
    t.assertFalse(doAssert(test.knownRoLongInteger))
    t.assertFalse(doAssert(test.knownRoString))

    teardown_brsHamcrest_TypeMatchers()
end sub


' aDouble()
sub test_aDouble (t as Object)
    test = setup_brsHamcrest_TypeMatchers()

    'GIVEN'
    doAssert = function (testValue as Dynamic) as Boolean
        return (aDouble().doMatch(testValue))
    end function

    'WHEN'

    'THEN'
    t.assertFalse(doAssert(test.knownBoolean))
    t.assertTrue(doAssert(42#))
    t.assertFalse(doAssert(test.knownFloat))
    t.assertFalse(doAssert(test.knownFunction))
    t.assertFalse(doAssert(test.knownInteger))
    t.assertFalse(doAssert(test.knownInvalid))
    t.assertFalse(doAssert(test.knownLongInteger))
    t.assertFalse(doAssert(test.knownString))

    t.assertFalse(doAssert(test.knownRoArray))
    t.assertFalse(doAssert(test.knownRoAssociativeArray))
    t.assertFalse(doAssert(test.knownRoBoolean))
    t.assertTrue(doAssert(test.knownRoDouble))
    t.assertFalse(doAssert(test.knownRoFloat))
    t.assertFalse(doAssert(test.knownRoFunction))
    t.assertFalse(doAssert(test.knownRoInt))
    t.assertFalse(doAssert(test.knownRoInvalid))
    t.assertFalse(doAssert(test.knownRoLongInteger))
    t.assertFalse(doAssert(test.knownRoString))

    teardown_brsHamcrest_TypeMatchers()
end sub


' aFloat()
sub test_aFloat (t as Object)
    test = setup_brsHamcrest_TypeMatchers()

    'GIVEN'
    doAssert = function (testValue as Dynamic) as Boolean
        return (aFloat().doMatch(testValue))
    end function

    'WHEN'

    'THEN'
    t.assertFalse(doAssert(test.knownBoolean))
    t.assertFalse(doAssert(42#))
    t.assertTrue(doAssert(test.knownFloat))
    t.assertFalse(doAssert(test.knownFunction))
    t.assertFalse(doAssert(test.knownInteger))
    t.assertFalse(doAssert(test.knownInvalid))
    t.assertFalse(doAssert(test.knownLongInteger))
    t.assertFalse(doAssert(test.knownString))

    t.assertFalse(doAssert(test.knownRoArray))
    t.assertFalse(doAssert(test.knownRoAssociativeArray))
    t.assertFalse(doAssert(test.knownRoBoolean))
    t.assertFalse(doAssert(test.knownRoDouble))
    t.assertTrue(doAssert(test.knownRoFloat))
    t.assertFalse(doAssert(test.knownRoFunction))
    t.assertFalse(doAssert(test.knownRoInt))
    t.assertFalse(doAssert(test.knownRoInvalid))
    t.assertFalse(doAssert(test.knownRoLongInteger))
    t.assertFalse(doAssert(test.knownRoString))

    teardown_brsHamcrest_TypeMatchers()
end sub


' aFunction()
sub test_aFunction (t as Object)
    test = setup_brsHamcrest_TypeMatchers()

    'GIVEN'
    doAssert = function (testValue as Dynamic) as Boolean
        return (aFunction().doMatch(testValue))
    end function

    'WHEN'

    'THEN'
    t.assertFalse(doAssert(test.knownBoolean))
    t.assertFalse(doAssert(42#))
    t.assertFalse(doAssert(test.knownFloat))
    t.assertTrue(doAssert(test.knownFunction))
    t.assertFalse(doAssert(test.knownInteger))
    t.assertFalse(doAssert(test.knownInvalid))
    t.assertFalse(doAssert(test.knownLongInteger))
    t.assertFalse(doAssert(test.knownString))

    t.assertFalse(doAssert(test.knownRoArray))
    t.assertFalse(doAssert(test.knownRoAssociativeArray))
    t.assertFalse(doAssert(test.knownRoBoolean))
    t.assertFalse(doAssert(test.knownRoDouble))
    t.assertFalse(doAssert(test.knownRoFloat))
    t.assertTrue(doAssert(test.knownRoFunction))
    t.assertFalse(doAssert(test.knownRoInt))
    t.assertFalse(doAssert(test.knownRoInvalid))
    t.assertFalse(doAssert(test.knownRoLongInteger))
    t.assertFalse(doAssert(test.knownRoString))

    teardown_brsHamcrest_TypeMatchers()
end sub


' aInteger() / anInteger()
sub test_aInteger (t as Object)
    test = setup_brsHamcrest_TypeMatchers()

    'GIVEN'
    doAssert = function (testValue as Dynamic) as Boolean
        return (aInteger().doMatch(testValue) AND anInteger().doMatch(testValue))
    end function

    'WHEN'

    'THEN'
    t.assertFalse(doAssert(test.knownBoolean))
    t.assertFalse(doAssert(42#))
    t.assertFalse(doAssert(test.knownFloat))
    t.assertFalse(doAssert(test.knownFunction))
    t.assertTrue(doAssert(test.knownInteger))
    t.assertFalse(doAssert(test.knownInvalid))
    t.assertFalse(doAssert(test.knownLongInteger))
    t.assertFalse(doAssert(test.knownString))

    t.assertFalse(doAssert(test.knownRoArray))
    t.assertFalse(doAssert(test.knownRoAssociativeArray))
    t.assertFalse(doAssert(test.knownRoBoolean))
    t.assertFalse(doAssert(test.knownRoDouble))
    t.assertFalse(doAssert(test.knownRoFloat))
    t.assertFalse(doAssert(test.knownRoFunction))
    t.assertTrue(doAssert(test.knownRoInt))
    t.assertFalse(doAssert(test.knownRoInvalid))
    t.assertFalse(doAssert(test.knownRoLongInteger))
    t.assertFalse(doAssert(test.knownRoString))

    teardown_brsHamcrest_TypeMatchers()
end sub


' aInvalid() / anInvalid()
sub test_aInvalid (t as Object)
    test = setup_brsHamcrest_TypeMatchers()

    'GIVEN'
    doAssert = function (testValue as Dynamic) as Boolean
        return (aInvalid().doMatch(testValue) AND anInvalid().doMatch(testValue))
    end function

    'WHEN'

    'THEN'
    t.assertFalse(doAssert(test.knownBoolean))
    t.assertFalse(doAssert(42#))
    t.assertFalse(doAssert(test.knownFloat))
    t.assertFalse(doAssert(test.knownFunction))
    t.assertFalse(doAssert(test.knownInteger))
    t.assertTrue(doAssert(test.knownInvalid))
    t.assertFalse(doAssert(test.knownLongInteger))
    t.assertFalse(doAssert(test.knownString))

    t.assertFalse(doAssert(test.knownRoArray))
    t.assertFalse(doAssert(test.knownRoAssociativeArray))
    t.assertFalse(doAssert(test.knownRoBoolean))
    t.assertFalse(doAssert(test.knownRoDouble))
    t.assertFalse(doAssert(test.knownRoFloat))
    t.assertFalse(doAssert(test.knownRoFunction))
    t.assertFalse(doAssert(test.knownRoInt))
    t.assertTrue(doAssert(test.knownRoInvalid))
    t.assertFalse(doAssert(test.knownRoLongInteger))
    t.assertFalse(doAssert(test.knownRoString))

    teardown_brsHamcrest_TypeMatchers()
end sub


' aLongInteger()
sub test_aLongInteger (t as Object)
    test = setup_brsHamcrest_TypeMatchers()

    'GIVEN'
    doAssert = function (testValue as Dynamic) as Boolean
        return (aLongInteger().doMatch(testValue))
    end function

    'WHEN'

    'THEN'
    t.assertFalse(doAssert(test.knownBoolean))
    t.assertFalse(doAssert(42#))
    t.assertFalse(doAssert(test.knownFloat))
    t.assertFalse(doAssert(test.knownFunction))
    t.assertFalse(doAssert(test.knownInteger))
    t.assertFalse(doAssert(test.knownInvalid))
    t.assertTrue(doAssert(test.knownLongInteger))
    t.assertFalse(doAssert(test.knownString))

    t.assertFalse(doAssert(test.knownRoArray))
    t.assertFalse(doAssert(test.knownRoAssociativeArray))
    t.assertFalse(doAssert(test.knownRoBoolean))
    t.assertFalse(doAssert(test.knownRoDouble))
    t.assertFalse(doAssert(test.knownRoFloat))
    t.assertFalse(doAssert(test.knownRoFunction))
    t.assertFalse(doAssert(test.knownRoInt))
    t.assertFalse(doAssert(test.knownRoInvalid))
    t.assertTrue(doAssert(test.knownRoLongInteger))
    t.assertFalse(doAssert(test.knownRoString))

    teardown_brsHamcrest_TypeMatchers()
end sub


' aNumber()
sub test_aNumber (t as Object)
    test = setup_brsHamcrest_TypeMatchers()

    'GIVEN'
    doAssert = function (testValue as Dynamic) as Boolean
        return (aNumber().doMatch(testValue))
    end function

    'WHEN'

    'THEN'
    t.assertFalse(doAssert(test.knownBoolean))
    t.assertTrue(doAssert(42#))
    t.assertTrue(doAssert(test.knownFloat))
    t.assertFalse(doAssert(test.knownFunction))
    t.assertTrue(doAssert(test.knownInteger))
    t.assertFalse(doAssert(test.knownInvalid))
    t.assertTrue(doAssert(test.knownLongInteger))
    t.assertFalse(doAssert(test.knownString))

    t.assertFalse(doAssert(test.knownRoArray))
    t.assertFalse(doAssert(test.knownRoAssociativeArray))
    t.assertFalse(doAssert(test.knownRoBoolean))
    t.assertTrue(doAssert(test.knownRoDouble))
    t.assertTrue(doAssert(test.knownRoFloat))
    t.assertFalse(doAssert(test.knownRoFunction))
    t.assertTrue(doAssert(test.knownRoInt))
    t.assertFalse(doAssert(test.knownRoInvalid))
    t.assertTrue(doAssert(test.knownRoLongInteger))
    t.assertFalse(doAssert(test.knownRoString))

    teardown_brsHamcrest_TypeMatchers()
end sub


' aString()
sub test_aString (t as Object)
    test = setup_brsHamcrest_TypeMatchers()

    'GIVEN'
    doAssert = function (testValue as Dynamic) as Boolean
        return (aString().doMatch(testValue))
    end function

    'WHEN'

    'THEN'
    t.assertFalse(doAssert(test.knownBoolean))
    t.assertFalse(doAssert(42#))
    t.assertFalse(doAssert(test.knownFloat))
    t.assertFalse(doAssert(test.knownFunction))
    t.assertFalse(doAssert(test.knownInteger))
    t.assertFalse(doAssert(test.knownInvalid))
    t.assertFalse(doAssert(test.knownLongInteger))
    t.assertTrue(doAssert(test.knownString))

    t.assertFalse(doAssert(test.knownRoArray))
    t.assertFalse(doAssert(test.knownRoAssociativeArray))
    t.assertFalse(doAssert(test.knownRoBoolean))
    t.assertFalse(doAssert(test.knownRoDouble))
    t.assertFalse(doAssert(test.knownRoFloat))
    t.assertFalse(doAssert(test.knownRoFunction))
    t.assertFalse(doAssert(test.knownRoInt))
    t.assertFalse(doAssert(test.knownRoInvalid))
    t.assertFalse(doAssert(test.knownRoLongInteger))
    t.assertTrue(doAssert(test.knownRoString))

    teardown_brsHamcrest_TypeMatchers()
end sub

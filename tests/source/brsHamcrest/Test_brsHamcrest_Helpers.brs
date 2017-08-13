' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


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

    hamcrestOptions = HamcrestOptions()
    hamcrestOptions.testMode = True

    return test
end function

'Clean up after running a unit test
function teardown_brsHamcrest_Helpers () as Void
    GetGlobalAA().brsHamcrestOptionsSingleton = Invalid
end function

' UNIT TESTS

' HamcrestOptions()
sub test_HamcrestOptions_firstUse (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    globalAA = GetGlobalAA()
    globalAA.Delete("brsHamcrestOptionsSingleton")

    'WHEN'
    HamcrestOptions()
    result = globalAA.Lookup("brsHamcrestOptionsSingleton")

    'THEN'
    t.assertNotInvalid(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_HamcrestOptions_subsequentUse (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    globalAA = GetGlobalAA()
    HamcrestOptions()

    'WHEN'
    HamcrestOptions()
    result = globalAA.Lookup("brsHamcrestOptionsSingleton")

    'THEN'
    t.assertNotInvalid(result)

    teardown_brsHamcrest_Helpers()
end sub


' HamcrestError()
sub test_HamcrestError_suppressed (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    options = HamcrestOptions()
    options.errors.suppressErrors = true

    'WHEN'
    result = HamcrestError("foobar")

    'THEN'
    t.assertInvalid(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_HamcrestError_notSuppressedDoStop (t as Object)
    'FIXME: Currently cannot unit test that a deliberate BrightScript STOP occurs.
    t.assertTrue(true)
end sub


sub test_HamcrestError_notSuppressedDoNotStop (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    options = HamcrestOptions()
    options.errors.suppressErrors = false
    options.errors.stopOnErrors = false

    'WHEN'
    result = HamcrestError("foobar")

    'THEN'
    t.assertNotInvalid(result)

    teardown_brsHamcrest_Helpers()
end sub


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


' IsEnumerable()
sub test_IsEnumerable_true (t as Object)
    test = setup_brsHamcrest_Helpers

    'GIVEN'
    foo = CreateObject("roAssociativeArray")

    'WHEN'
    result = IsEnumerable(foo)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub

sub test_IsEnumerable_false (t as Object)
    test = setup_brsHamcrest_Helpers

    'GIVEN'
    foo = CreateObject("roDateTime")

    'WHEN'
    result = IsEnumerable(foo)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


' CoreDoMatch()
sub test_CoreDoMatch_withIdenticalDataTypes (t as Object)
    test = setup_brsHamcrest_Helpers

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownString: "knownStringParam"
            knownInteger: 1
            knownBoolean: true
            knownFloat: 1/3
            knownDouble: 2.3#
            knownLongInteger: 987654321&
        }
    end function
    'WHEN'
    result = CoreDoMatch(getFooObj(), getFooObj())
    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_CoreDoMatch_withDifferentDataTypes (t as Object)
    test = setup_brsHamcrest_Helpers

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownString: "knownString"
            knownInteger: 1
            knownBoolean: true
        }
    end function

    getDifferentFooObj = function () as Object
        return {
            knownString: "knownString"
            differentString: "differentString"
            knownInteger: 1
            knownBoolean: true
        }
    end function
    'WHEN'
    result = CoreDoMatch(getFooObj(), getDifferentFooObj())
    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_CoreDoMatch_withSameKeysDifferentValues (t as Object)
    test = setup_brsHamcrest_Helpers

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownString: "knownString1"
            knownInteger: 1
            knownBoolean: true
        }
    end function

    getDifferentFooObj = function () as Object
        return {
            knownString: "knownString2"
            knownInteger: 2
            knownBoolean: false
        }
    end function
    'WHEN'
    result = CoreDoMatch(getFooObj(), getDifferentFooObj())
    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_CoreDoMatch_withIdenticalAPI (t as Object)
    test = setup_brsHamcrest_Helpers

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownFunction1: function ()
            end function
            knownFunction2: function ()
            end function
            knownFunction3: function ()
            end function
        }
    end function
    'WHEN'
    result = CoreDoMatch(getFooObj(), getFooObj())
    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_CoreDoMatch_withDifferentAPI (t as Object)
    test = setup_brsHamcrest_Helpers

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownFunction1: function ()
            end function
            knownFunction2: function ()
            end function
            knownFunction3: function ()
            end function
        }
    end function
    target = getFooObj()
    comparison = getFooObj()
    comparison.additionalFunction = function ()
    end function
    'WHEN'
    result = CoreDoMatch(target, comparison)
    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_CoreDoMatch_withIdenticalCollectionDataTypes (t as Object)
    test = setup_brsHamcrest_Helpers

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownArray: ["foo", "bar"]
            knownAssocArray: {
                foo: "bar"
                flag: true
            }
        }
    end function
    'WHEN'
    result = CoreDoMatch(getFooObj(), getFooObj())
    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_CoreDoMatch_withdifferentCollectionData (t as Object)
    test = setup_brsHamcrest_Helpers

    'GIVEN'
    getFooObj = function () as Object
        return {
            knownArray: ["foo", "bar"]
            knownAssocArray: {
                foo: "bar"
                flag: true
            }
        }
    end function
    target = getFooObj()
    comparison = getFooObj()
    comparison.knownArray = ["foo", "bar", "two"]
    'WHEN'
    result = CoreDoMatch(target, comparison)
    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


'IsMatcher
sub test_IsMatcher_AllCorrectMethods (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    targetObj = BaseMatcher()

    'WHEN'
    result = IsMatcher(targetObj)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_IsMatcher_SomeCorrectMethods (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    targetObj = BaseMatcher()
    targetObj.Delete(targetObj.Keys()[0])

    'WHEN'
    result = IsMatcher(targetObj)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_IsMatcher_NoCorrectMethods (t as Object)

    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    targetObj = {
        foo: function () as Void
        end function
    }

    'WHEN'
    result = IsMatcher(targetObj)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub

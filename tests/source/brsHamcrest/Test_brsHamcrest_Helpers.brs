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
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    foo = CreateObject("roAssociativeArray")

    'WHEN'
    result = IsEnumerable(foo)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub

sub test_IsEnumerable_false (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    foo = CreateObject("roDateTime")

    'WHEN'
    result = IsEnumerable(foo)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_coreDoMatch_withIdenticalDataTypes (t as Object)
    test = setup_brsHamcrest_Helpers()

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
    result = coreDoMatch(getFooObj(), getFooObj())
    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_coreDoMatch_withDifferentDataTypes (t as Object)
    test = setup_brsHamcrest_Helpers()

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
    result = coreDoMatch(getFooObj(), getDifferentFooObj())
    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_coreDoMatch_withSameKeysDifferentValues (t as Object)
    test = setup_brsHamcrest_Helpers()

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
    result = coreDoMatch(getFooObj(), getDifferentFooObj())
    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_coreDoMatch_withIdenticalAPI (t as Object)
    test = setup_brsHamcrest_Helpers()

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
    result = coreDoMatch(getFooObj(), getFooObj())
    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_coreDoMatch_withDifferentAPI (t as Object)
    test = setup_brsHamcrest_Helpers()

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
    result = coreDoMatch(target, comparison)
    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_coreDoMatch_withIdenticalCollectionDataTypes (t as Object)
    test = setup_brsHamcrest_Helpers()

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
    result = coreDoMatch(getFooObj(), getFooObj())
    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_coreDoMatch_withdifferentCollectionData (t as Object)
    test = setup_brsHamcrest_Helpers()

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
    result = coreDoMatch(target, comparison)
    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_coreDoMatch_withNonStrictTypeMatching (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    target = {
        propString: "foo"
        propBoolean: true
        propInteger: 2
        propNumber:  1.2345
    }
    'XXX: Parsing the object as a json string will create non-strict types (e.g. "String"
    '     instead of "roString"). But these properties should still actually match.
    comparison = ParseJson("{""propString"": ""foo"",""propBoolean"": true,""propInteger"": 2,""propNumber"": 1.2345}")
    'WHEN'
    result = coreDoMatch(target, comparison)
    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub


sub test_coreDoMatch_withItemsApiMethodOverwritten (t as Object)
    test = setup_brsHamcrest_Helpers()

    'GIVEN'
    getFooObj = function () as Object
        return {
            items: ["item1","item2","item3"]
            knownString: "knownStringParam"
            knownInteger: 1
            knownBoolean: true
            knownFloat: 1/3
            knownDouble: 2.3#
            knownLongInteger: 987654321&
        }
    end function
    'WHEN'
    result = coreDoMatch(getFooObj(), getFooObj())
    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_Helpers()
end sub





sub test_coreDoMatch_targetAndValueAreIdenticalObjects_withDifferentKeyOrder (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = {
        lorem: false
        ipsum: "dolor sit amet"
        consectetur: "adipiscing elit"
        sed: "do"
        eiusmod: "tempor"
        incididunt: 0
        ut: "labore et dolore"
        magna : "aliqua"
        enim: "ad minim veniam"
        quis: 20.99
        nostrud: "exercitation ullamco laboris"
        nisi: false
        aliquip: "ex ea commodo"
        consequat: "Duis aute irure dolor"
        reprehenderit: "in voluptate velit esse "
        cillum: "dolore eu fugiat nulla"
        pariatur: true
    }

    testValue = {
        consectetur: "adipiscing elit"
        lorem: false
        pariatur: true
        sed: "do"
        cillum: "dolore eu fugiat nulla"
        eiusmod: "tempor"
        nostrud: "exercitation ullamco laboris"
        reprehenderit: "in voluptate velit esse "
        ut: "labore et dolore"
        consequat: "Duis aute irure dolor"
        magna : "aliqua"
        aliquip: "ex ea commodo"
        nisi: false
        ipsum: "dolor sit amet"
        enim: "ad minim veniam"
        quis: 20.99
        incididunt: 0
    }

    'WHEN'
    result = coreDoMatch(testTarget, testValue)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_ObjectMatchers()
end sub


sub test_BrsHamcrestNormaliseType_normaliseAllKnownTypes (t as Object)
    test = setup_brsHamcrest_Helpers()

    'WHEN'
    normalisedRoArrayType = BrsHamcrestNormaliseType("roArray")
    normalisedRoAssocArrayType = BrsHamcrestNormaliseType("roAssociativeArray")
    normalisedRoBooleanType = BrsHamcrestNormaliseType("roBoolean")
    normalisedBooleanType = BrsHamcrestNormaliseType("Boolean")
    normalisedRoDoubleType = BrsHamcrestNormaliseType("roDouble")
    normalisedDoubleType = BrsHamcrestNormaliseType("Double")
    normalisedRoIntrinsicDoubleType = BrsHamcrestNormaliseType("roIntrinsicDouble")
    normalisedRoFloatType = BrsHamcrestNormaliseType("roFloat")
    normalisedFloatType = BrsHamcrestNormaliseType("Float")
    normalisedRoFunctionType = BrsHamcrestNormaliseType("roFunction")
    normalisedFunctionType = BrsHamcrestNormaliseType("Function")
    normalisedRoIntegerType = BrsHamcrestNormaliseType("roInteger")
    normalisedRoIntType = BrsHamcrestNormaliseType("roInt")
    normalisedIntegerType = BrsHamcrestNormaliseType("Integer")
    normalisedRoLongIntegerType = BrsHamcrestNormaliseType("roLongInteger")
    normalisedLongIntegerType = BrsHamcrestNormaliseType("LongInteger")
    normalisedStringType = BrsHamcrestNormaliseType("String")
    normalisedRoStringType = BrsHamcrestNormaliseType("roString")

    'THEN'
    t.assertEqual("roArray", normalisedRoArrayType)
    t.assertEqual("roAssociativeArray", normalisedRoAssocArrayType)
    t.assertEqual("roDouble", normalisedRoDoubleType)
    t.assertEqual("roDouble", normalisedDoubleType)
    t.assertEqual("roDouble", normalisedRoIntrinsicDoubleType)
    t.assertEqual("roFloat", normalisedRoFloatType)
    t.assertEqual("roFloat", normalisedFloatType)
    t.assertEqual("roFunction", normalisedRoFunctionType)
    t.assertEqual("roFunction", normalisedFunctionType)
    t.assertEqual("roInteger", normalisedRoIntegerType)
    t.assertEqual("roInteger", normalisedRoIntType)
    t.assertEqual("roInteger", normalisedIntegerType)
    t.assertEqual("roLongInteger", normalisedRoLongIntegerType)
    t.assertEqual("roLongInteger", normalisedLongIntegerType)
    t.assertEqual("roString", normalisedStringType)
    t.assertEqual("roString", normalisedRoStringType)

    teardown_brsHamcrest_Helpers()
end sub


sub test_BrsHamcrestNormaliseType_normaliseUnknownTypes (t as Object)
    test = setup_brsHamcrest_Helpers()

    'WHEN'
    normalisedUnknownType = BrsHamcrestNormaliseType("unknownType")

    'THEN'
    t.assertEqual(normalisedUnknownType, "<ERROR:UNSUPPORTED_TYPE>")

    teardown_brsHamcrest_Helpers()
end sub

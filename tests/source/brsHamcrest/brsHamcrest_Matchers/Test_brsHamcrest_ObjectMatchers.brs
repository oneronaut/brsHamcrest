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
sub test_sameObjectAs_sharedObjectInstance (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = {foo: "bar"}
    testValue = testTarget

    'WHEN'
    result = sameObjectAs(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)
    t.assertEqual(testTarget.Keys().count(), 1)
    t.assertEqual(testValue.Keys().count(), 1)

    teardown_brsHamcrest_ObjectMatchers()
end sub


sub test_sameObjectAs_sharedArrayInstance (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = [{foo: "bar"}, 2, true]
    testValue = testTarget

    'WHEN'
    result = sameObjectAs(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)
    t.assertEqual(testTarget.count(), 3)
    t.assertEqual(testValue.count(), 3)

    teardown_brsHamcrest_ObjectMatchers()
end sub


sub test_sameObjectAs_differentObjectInstances (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = {foo: "bar"}
    testValue = {bar: "foo"}

    'WHEN'
    result = sameObjectAs(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)
    t.assertEqual(testTarget.Keys().count(), 1)
    t.assertEqual(testValue.Keys().count(), 1)

    teardown_brsHamcrest_ObjectMatchers()
end sub


sub test_sameObjectAs_differentArrayInstances (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = [{foo: "bar"}, 2, true]
    testValue = [{foo: "bar"}, 2, true]

    'WHEN'
    result = sameObjectAs(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)
    t.assertEqual(testTarget.count(), 3)
    t.assertEqual(testValue.count(), 3)

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
    t.assertEqual(testValue.Keys().count(), 1)

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
    t.assertEqual(testTarget.Keys().count(), 1)

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


' identicalTo()
sub test_identicalTo_targetAndValueAreNotObjectsOrArrays (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = 123
    testValue = "foo"

    'WHEN'
    result = identicalTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_ObjectMatchers()
end sub


sub test_identicalTo_targetAndValueAreIdenticalObjects (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = {foo: "bar", two: 2, flag: true}
    testValue = {foo: "bar", two: 2, flag: true}

    'WHEN'
    result = identicalTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_ObjectMatchers()
end sub


sub test_identicalTo_targetAndValueAreIdenticalArrays (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = [{foo: "bar"}, 2, true]
    testValue = [{foo: "bar"}, 2, true]

    'WHEN'
    result = identicalTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_ObjectMatchers()
end sub


sub test_identicalTo_targetAndValueAreNOTIdenticalObjects (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = {foo: "bar", two: 2, flag: true}
    testValue = {foo: "bar", two: 2, flag: false}

    'WHEN'
    result = identicalTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_ObjectMatchers()
end sub


sub test_identicalTo_targetAndValueAreNOTIdenticalArrays (t as Object)
    test = setup_brsHamcrest_ObjectMatchers()

    'GIVEN'
    testTarget = [{foo: "bar"}, 2, true]
    testValue = [{foo: "another bar"}, 1, true]

    'WHEN'
    result = identicalTo(testValue).doMatch(testTarget)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_ObjectMatchers()
end sub

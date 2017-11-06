' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


' SETUP / TEARDOWN

'Set up the unit tests
'
'@return {Object} The test helper
function setup_brsHamcrest_CollectionMatchers () as Object
    test = {
        knownString: "knownString"
    }
    return test
end function

'Clean up after running a unit test
function teardown_brsHamcrest_CollectionMatchers () as Void

end function

' UNIT TESTS

' anEmptyCollection()
sub test_anEmptyCollection_emptyArray (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testCollection = CreateObject("roArray", 0, false)

    'WHEN'
    result = anEmptyCollection().doMatch(testCollection)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_anEmptyCollection_emptyAssocArray (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testCollection = CreateObject("roAssociativeArray")

    'WHEN'
    result = anEmptyCollection().doMatch(testCollection)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_anEmptyCollection_emptyList (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testCollection = CreateObject("roList")

    'WHEN'
    result = anEmptyCollection().doMatch(testCollection)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_anEmptyCollection_emptyByteArray (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testCollection = CreateObject("roByteArray")

    'WHEN'
    result = anEmptyCollection().doMatch(testCollection)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_anEmptyCollection_emptyXMLList (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testCollection = CreateObject("roXMLList")

    'WHEN'
    result = anEmptyCollection().doMatch(testCollection)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_anEmptyCollection_populatedArray (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testCollection = [1, 2, 3]

    'WHEN'
    result = anEmptyCollection().doMatch(testCollection)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_anEmptyCollection_populatedAssocArray (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testCollection = {foo: "bar"}

    'WHEN'
    result = anEmptyCollection().doMatch(testCollection)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_anEmptyCollection_populatedList (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testCollection = CreateObject("roList")
    testCollection.addTail("foo")

    'WHEN'
    result = anEmptyCollection().doMatch(testCollection)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_anEmptyCollection_populatedByteArray (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testCollection = CreateObject("roByteArray")
    testCollection.fromAsciiString("foo")

    'WHEN'
    result = anEmptyCollection().doMatch(testCollection)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_anEmptyCollection_populatedXMLList (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testCollection = CreateObject("roXMLList")
    elem = CreateObject("roXMLElement")
    testCollection.addTail(elem)

    'WHEN'
    result = anEmptyCollection().doMatch(testCollection)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_anEmptyCollection_targetIsIncorrectType (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    incorrectType = "foo"

    'WHEN'
    result = anEmptyCollection().doMatch(incorrectType)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


'containsKeys()
sub test_containsKeys_assocArrayHasAllKeys (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testKeyArray = ["foo", "bar"]
    testAssocArray = {foo: "a", bar: "b"}

    'WHEN'
    result = containsKeys(testKeyArray).doMatch(testAssocArray)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_containsKeys_assocArrayHasSomeKeys (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testKeyArray = ["foo", "bar"]
    testAssocArray = {foo: "a"}

    'WHEN'
    result = containsKeys(testKeyArray).doMatch(testAssocArray)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_containsKeys_assocArrayHasMoreKeys (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testKeyArray = ["foo"]
    testAssocArray = {foo: "a", bar: "b"}

    'WHEN'
    result = containsKeys(testKeyArray).doMatch(testAssocArray)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_containsKeys_keyArrayIsEmpty (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testKeyArray = []
    testAssocArray = {foo: "a", bar: "b"}

    'WHEN'
    result = containsKeys(testKeyArray).doMatch(testAssocArray)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_containsKeys_assocArrayIsEmpty (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testKeyArray = ["foo", "bar"]
    testAssocArray = {}

    'WHEN'
    result = containsKeys(testKeyArray).doMatch(testAssocArray)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_containsKeys_assocArrayIsIncorrectType (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testKeyArray = ["foo", "bar"]
    incorrectType = "foo"

    'WHEN'
    result = containsKeys(testKeyArray).doMatch(incorrectType)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


'containsKeyValuePairs()
sub test_containsKeyValuePairs_hasAllKeyValuePairs (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testKeyValuePairArray = {foo0: "bar0", foo1: "bar1", foo2: "bar2"}
    testAssocArray = {foo0: "bar0", foo1: "bar1", foo2: "bar2"}

    'WHEN'
    result = containsKeyValuePairs(testKeyValuePairArray).doMatch(testAssocArray)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_containsKeyValuePairs_hasComplexKeyValuePairs (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testKeyValuePairArray = {foo0: {subFoo0:{foo:true,bar:"2"}, subFoo2:true}, foo1: [0,5,2,8,7,8,9,3,1,1], foo2: "bar2"}
    testAssocArray = {foo0: {subFoo0:{foo:true,bar:"2"}, subFoo2:true}, foo1: [0,5,2,8,7,8,9,3,1,1], foo2: "bar2"}

    'WHEN'
    result = containsKeyValuePairs(testKeyValuePairArray).doMatch(testAssocArray)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_containsKeyValuePairs_hasSomeKeyValuePairs (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testKeyValuePairArray = {foo0: "bar0", foo1: "bar1", foo2: "bar2"}
    testAssocArray = {foo0: "bar0", foo1: "bar1"}

    'WHEN'
    result = containsKeyValuePairs(testKeyValuePairArray).doMatch(testAssocArray)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_containsKeyValuePairs_hasNoKeyValuePairs (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testKeyValuePairArray = {foo0: "bar0", foo1: "bar1", foo2: "bar2"}
    testAssocArray = {}

    'WHEN'
    result = containsKeyValuePairs(testKeyValuePairArray).doMatch(testAssocArray)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_containsKeyValuePairs_targetIsIncorrectType (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testKeyValuePairArray = {foo0: "bar0", foo1: "bar1", foo2: "bar2"}
    incorrectType = "foo"

    'WHEN'
    result = containsKeyValuePairs(testKeyValuePairArray).doMatch(incorrectType)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


'inCollection()
sub test_inCollection_simpleTypeTrue (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testValue = test.knownString
    testCollection = ["foo", "bar", test.knownString]

    'WHEN'
    result = inCollection(testCollection).doMatch(testValue)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_inCollection_simpleTypeFalse (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testValue = test.knownString
    testCollection = ["foo", "bar"]

    'WHEN'
    result = inCollection(testCollection).doMatch(testValue)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_inCollection_assocArrayTrue (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testAssocArray = {foo2: "bar2"}
    testCollection = [{foo: "bar"}, {foo1: "bar1"}, {foo2: "bar2"}]

    'WHEN'
    result = inCollection(testCollection).doMatch(testAssocArray)

    'THEN'
    t.assertTrue(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub


sub test_inCollection_assocArrayFalse (t as Object)
    test = setup_brsHamcrest_CollectionMatchers()

    'GIVEN'
    testAssocArray = {foo2: "bar2"}
    testCollection = [{foo: "bar"}, {foo1: "bar1"}]

    'WHEN'
    result = inCollection(testCollection).doMatch(testAssocArray)

    'THEN'
    t.assertFalse(result)

    teardown_brsHamcrest_CollectionMatchers()
end sub

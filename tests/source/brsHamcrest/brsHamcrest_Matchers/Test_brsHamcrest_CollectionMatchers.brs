' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################
'                 Copyright (c) 2016 Benjamin Hill

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
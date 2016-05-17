' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################
'                 Copyright (c) 2016 Benjamin Hill


'Matcher to test the given collection contains zero elements
'
'Example:
'assertThat(foo, is(anEmptyCollection()))
'
'@return {Object<Matcher>} A Matcher
function anEmptyCollection () as Object
    matcher = BaseMatcher()

    matcher.doMatch = function (target as Dynamic) as Boolean
        retVal = false
        if (HasInterface(target, "ifEnum"))
            if target.IsEmpty() then retVal = true
        else
            HamcrestError("Type Mismatch: The target object is not an enumerable type.")
        end if
        return retVal
    end function

    return matcher
end function


'Matcher to test the given collection contains the given keys
'
'Example:
'assertThat(foo, containsKeys([key1, key2, ...]))
'
'@param keyArray {Object<Array>} Array of keys to look for
'@return {Object<Matcher>} A Matcher
function containsKeys (keyArray as Object) as Object
    matcher = BaseMatcher()

    matcher.keyArray = keyArray

    matcher.doMatch = function (target as Dynamic) as Boolean
        result = false
        if (type(m.keyArray) = "roArray")
            if (NOT m.keyArray.IsEmpty())
                if (HasInterface(target, "ifEnum"))
                    failure = false
                    for each key in m.keyArray
                        if (target[key] = Invalid) then failure = true
                    end for
                    result = (NOT failure)
                else
                    HamcrestError("Type Mismatch: Expected an enumerable type and encountered a "+type(target))
                end if
            end if
        else
            HamcrestError("Type Mismatch: Expected a roArray and encountered a "+type(m.keyArray))
        end if
        return result
    end function

    return matcher
end function


'Matcher to test the given collection contains zero elements
'
'Example:
'assertThat(foo, containsKeyValuePairs({key1: value1, key2: value2, ...}))
'
'@param keyValuePairs {Object<AssociativeArray>} Associative Array of key-value pairs to look for
'@return {Object<Matcher>} A Matcher
function containsKeyValuePairs (keyValuePairs as Object) as Boolean
    matcher = BaseMatcher()

    matcher.doMatch = function (target as Dynamic) as Boolean
        retVal = false
        if (type(target) = "roAssociativeArray" AND type(keyValuePairsArray) = "roAssociativeArray")
            failure = false
            for each key in keyValuePairs
                if (target[key] = Invalid OR (target[key] <> Invalid AND target[key] <> keyValuePairs[key])) then failure = true
            end for
            result = (NOT failure)
        else
            HamcrestError("Type Mismatch: Expected an Associative Array and encountered a "+type(target))
        end if
        return retVal
    end function

    return matcher
end function


'Matcher to test a value is in a given collection
'
'Example:
'assertThat(foo, is(inCollection(bar)))
'
'@param collection {Object<Collection>} Collection object (implements ifEnum)
'@return {Object<Matcher>} A Matcher
function inCollection (collection as Object) as Object
    matcher = BaseMatcher()

    matcher.collection = collection

    matcher.doMatch = function (target as Dynamic) as Boolean
        retVal = false
        if (GetInterface(m.collection, "ifEnum") <> Invalid)
            failure = false
            for each value in m.collection
                if (GetInterface(value, "ifEnum") <> Invalid)
                    if (NOT inCollection(value).doMatch(target))
                        failure = true
                    end if
                else if (value <> target)
                    failure = true
                end if
            end for
            result = (NOT failure)
        else
            HamcrestError("Type Mismatch: Expected a Collection (implements ifEnum) and encountered a "+type(m.collection))
        end if
        return retVal
    end function

    return matcher
end function

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
        if (GetInterface(target, "ifEnum") <> Invalid)
            if target.IsEmpty() then retVal = true
        else
            HamcrestError("Type Mismatch: The target object is not an enumerable type.")
        end if
        return retVal
    end function

    return matcher
end function


'Matcher to test the given collection contains zero elements
'
'Example:
'assertThat(foo, containsKeys([key1, key2, ...]))
'
'@param keyArray {Object<Array>} Array of keys to look for
'@return {Object<Matcher>} A Matcher
function containsKeys (keyArray as Object) as Object
    matcher = BaseMatcher()

    matcher.doMatch = function (target as Dynamic) as Boolean
        result = false
        if (GetInterface(target, "ifEnum") <> Invalid AND GetInterface(keyArray, "ifEnum"))
            failure = false
            for each key in keyArray
                if (target[key] = Invalid) then failure = true
            end for
            result = (NOT failure)
        else
            HamcrestError("Type Mismatch: The target object is not an enumerable type.")
        end if
        return retVal
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
        if (GetInterface(target, "ifAssociativeArray") <> Invalid AND GetInterface(keyValuePairsArray, "ifAssociativeArray"))
            failure = false
            for each key in keyValuePairs
                if (target[key] = Invalid OR (target[key] <> Invalid AND target[key] <> keyValuePairs[key])) then failure = true
            end for
            result = (NOT failure)
        else
            HamcrestError("Type Mismatch: The target object is not an Associative Array.")
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

    matcher.doMatch = function (target as Dynamic) as Boolean
        retVal = false
        if (GetInterface(collection, "ifEnum") <> Invalid)
            failure = false
            for each value in collection
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
            HamcrestError("Type Mismatch: Expected a Collection (implements ifEnum) and encountered a ";type(collection))
        end if
        return retVal
    end function

    return matcher
end function

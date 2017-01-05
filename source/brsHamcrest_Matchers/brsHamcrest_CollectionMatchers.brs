' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


'Matcher to test the given collection contains zero elements
'
'Example:
'assertThat(foo, is(anEmptyCollection()))
'
'@return {Object<Matcher>} A Matcher
function anEmptyCollection () as Object
    matcher = BaseMatcher()

    matcher.doMatch = function (target as Dynamic) as Boolean
        failure = false
        if (IsEnumerable(target))
            if (NOT target.IsEmpty()) then failure = true
        else
            HamcrestError("Type Mismatch: The target object is not an enumerable type.")
        end if
        return (NOT failure)
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
        failure = false
        if (type(m.keyArray) = "roArray")
            if (NOT m.keyArray.IsEmpty())
                if (HasInterface(target, "ifEnum"))
                    for each key in m.keyArray
                        if (target[key] = Invalid) then failure = true
                    end for
                else
                    HamcrestError("Type Mismatch: Expected an enumerable type and encountered a "+type(target))
                end if
            else
                failure = true
            end if
        else
            HamcrestError("Type Mismatch: Expected a roArray and encountered a "+type(m.keyArray))
        end if
        return (NOT failure)
    end function

    return matcher
end function


'Matcher to test the given collection contains the all of the key-value pairs in the given roAssociativeArray
'
'Example:
'assertThat(foo, containsKeyValuePairs({key1: value1, key2: value2, ...}))
'
'@param keyValuePairs {Object<AssociativeArray>} Associative Array of key-value pairs to look for
'@return {Object<Matcher>} A Matcher
function containsKeyValuePairs (keyValuePairs as Object) as Object
    matcher = BaseMatcher()

    matcher.keyValuePairs = keyValuePairs

    matcher.doMatch = function (target as Dynamic) as Boolean
        failure = false
        if (type(target) = "roAssociativeArray" AND type(m.keyValuePairs) = "roAssociativeArray")
            for each key in m.keyValuePairs
                if (target[key] = Invalid OR (target[key] <> Invalid AND target[key] <> m.keyValuePairs[key])) then failure = true
            end for
        else
            HamcrestError("Type Mismatch: Expected an Associative Array and encountered a "+type(target))
        end if
        return (NOT failure)
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
        if (IsEnumerable(m.collection))
            for each value in m.collection
                if (IsEnumerable(value))
                    if (inCollection(value).doMatch(target))
                        return true
                    end if
                else if (type(target) = "roAssociativeArray")
                    for each targetKey in target
                        if (targetKey = value AND target[targetKey] = m.collection[value])
                            return true
                        end if
                    end for
                else if (value = target)
                    return true
                end if
            end for
        else
            HamcrestError("Type Mismatch: Expected a Collection (implements ifEnum) and encountered a "+type(m.collection))
        end if
        return false
    end function

    return matcher
end function

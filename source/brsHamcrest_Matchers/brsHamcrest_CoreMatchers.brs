' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


'Decorates another Matcher, retaining its behaviour, but allowing tests to be slightly more expressive.
'If passed an array, then is() acts as a shortcut to allOf()
'
'Example:
'assertThat(foo, is(aString()))
'assertThat(foo, is([aString(), endsWithString("bar")]))
'
'@param matcher {Object<Matcher>} A Matcher
'@return {Object<Matcher>} A Matcher
function is (matcher as Object) as Object
    if type(matcher) = "roArray" then return allOf(matcher)
    return matcher
end function


'A matcher that has the correct structure, but returns true to anything, for the purposes of integration with frameworks
'
'Example:
'assertThat(foo, anything())
'
'@return {Object<Matcher>} A Matcher
function anything () as Object
    matcher = BaseMatcher()

    matcher.append({
        doMatch: function (target as Dynamic) as Boolean
            return true
        end function
        })

    return matcher
end function


'Creates a matcher that wraps an existing matcher, but inverts the logic by which it will match.
'If passed an array, isNot() acts as a shortcut to noneOf()
'
'Example:
'assertThat(foo, isNot(aString()))
'assertThat(foo, isNot([aString(), aNumber()]))
'
'@param matcher {Object<Matcher>} A Matcher
'@return {Object<Matcher>} A Matcher
function isNot (matcher as Object) as Object
    if type(matcher) = "roArray" then return noneOf(matcher)

    retVal = Invalid
    if (matcher.CLASS_TYPE = "Matcher")
        newMatcher = matcher

        newMatcher.doMatchOrig = newMatcher.doMatch
        newMatcher.doMatch = function (target as Dynamic) as Boolean
            return (NOT m.doMatchOrig(target))
        end function

        retVal = newMatcher
    else
        HamcrestError("Type Mismatch: Expected a Matcher and encountered a "+type(matcher))
    end if
    return retVal
end function


'Creates a matcher that checks against array of matchers, only passing if all matchers are positive.
'
'Example:
'assertThat(foo, is(allOf([aString(), inCollection(bar)])))
'
'@param arrayOfMatchers {Array<Matcher>} An array of Matchers
'@return {Object<Matcher>} A Matcher
function allOf (arrayOfMatchers as Object) as Object
    matcher = BaseMatcher()

    matcher.append({
        arrayOfMatchers: arrayOfMatchers

        doMatch: function (target as Dynamic) as Boolean
            failure = false
            if (type(m.arrayOfMatchers) = "roArray")
                for each matcherObj in m.arrayOfMatchers
                    if (matcherObj.CLASS_TYPE = "Matcher")
                        failure = (NOT matcherObj.doMatch(target))
                    else
                        HamcrestError("Type Mismatch: Expected a Matcher and encountered a "+type(matcherObj))
                    end if
                end for
            else
                HamcrestError("Type Mismatch: Expected an Array and encountered a "+type(m.arrayOfMatchers))
            end if
            return (NOT failure)
        end function
    })

    return matcher
end function


'Creates a matcher that checks against array of matchers, passing if any of the matchers are positive.
'
'Example:
'assertThat(foo, is(anyOf([aString(), inCollection(bar)])))
'
'@param arrayOfMatchers {Array<Matcher>} An array of Matchers
'@return {Object<Matcher>} A Matcher
function anyOf (arrayOfMatchers as Object) as Object
    matcher = BaseMatcher()

    matcher.append({
        arrayOfMatchers: arrayOfMatchers

        doMatch: function (target as Dynamic) as Boolean
            if (type(m.arrayOfMatchers) = "roArray")
                for each matcherObj in m.arrayOfMatchers
                    if (matcherObj.doMatch(target))
                        return true
                    end if
                end for
            else
                HamcrestError("Type Mismatch: Expected an Array and encountered a "+type(m.arrayOfMatchers))
            end if

            return false
        end function
    })

    return matcher
end function


'Creates a matcher that checks against array of matchers, only passing if none of the matchers are positive.
'
'Example:
'assertThat(foo, is(noneOf([aString(), inCollection(bar)])))
'
'@param arrayOfMatchers {Array<Matcher>} An array of Matchers
'@return {Object<Matcher>} A Matcher
function noneOf(arrayOfMatchers as Object) as Object
    matcher = BaseMatcher()

    matcher.append({
        arrayOfMatchers: arrayOfMatchers

        doMatch: function (target as Dynamic) as Boolean
            if (type(m.arrayOfMatchers) = "roArray")
                for each matcherObj in m.arrayOfMatchers
                    if (matcherObj.doMatch(target))
                        return false
                    end if
                end for
            else
                HamcrestError("Type Mismatch: Expected an Array and encountered a "+type(m.arrayOfMatchers))
            end if

            return true
        end function
    })

    return matcher
end function


'Creates a matcher that does an exact match, only passing if an exact match of both value and type are made.
'
'Example:
'assertThat(foo, is(equalTo(bar)))
'
'@param comparison - any value
'@return {Object<Matcher>} A Matcher
function equalTo(comparison as Dynamic) as Object
    matcher = BaseMatcher()

    matcher.append({
        comparison: comparison

        doMatch: function (target as Dynamic) as Boolean
            targetType = m._normaliseType(type(target))
            comparisonType = m._normaliseType(type(m.comparison))

            if (targetType = comparisonType)
                if (targetType = "roArray")
                    if (target.count() = m.comparison.count())
                        for i=0 to target.count()-1 Step 1
                            if (equalTo(m.comparison[i]).doMatch(target[i]) = false) return false
                        end for
                    else
                        return false
                    end if
                else if (targetType = "roAssociativeArray")
                    if (target.Count() = m.comparison.Count())
                        for each key in target
                            if (equalTo(m.comparison.LookupCI(key)).doMatch(target.LookupCI(key)) = false) return false
                        end for
                    else
                        return false
                    end if

                else if (targetType = "roBoolean" OR targetType = "roDouble" OR targetType = "roFloat" OR targetType = "roInteger" OR targetType = "roLongInteger" OR targetType = "roString" OR targetType = "roInvalid")
                    return (target = m.comparison)

                else if (targetType = "roFunction")
                    return (target.toStr() = m.comparison.toStr())

                else
                    return (targetType = comparisonType)
                end if
            else
                return false
            end if

            return true
        end function

        _normaliseType: function (typeIn as String) as String

                types = {
                    "roArray": "roArray"
                    "roAssociativeArray": "roAssociativeArray"
                    "roBoolean": "roBoolean"
                    "Boolean": "roBoolean"
                    "roDouble": "roDouble"
                    "Double": "roDouble"
                    "roIntrinsicDouble": "roDouble"
                    "roFloat": "roFloat"
                    "Float": "roFloat"
                    "roFunction": "roFunction"
                    "Function": "roFunction"
                    "roInteger": "roInteger"
                    "roInt": "roInteger"
                    "Integer": "roInteger"
                    "roLongInteger": "roLongInteger"
                    "LongInteger": "roLongInteger"
                    "roString": "roString"
                    "String": "roString"
                    "roInvalid": "roInvalid"
                    "Invalid": "roInvalid"
                }

                if (types.DoesExist(typeIn))
                    typeOut = types[typeIn]
                else
                    HamcrestError("Unsupported type cannot be normalised")
                    typeOut = "<ERROR:UNSUPPORTED_TYPE>"
                end if

                return typeOut
        end function
    })

    return matcher
end function

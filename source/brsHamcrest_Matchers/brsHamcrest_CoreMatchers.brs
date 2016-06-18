' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################
'                 Copyright (c) 2016 Benjamin Hill


'Decorates another Matcher, retaining its behaviour, but allowing tests to be slightly more expressive.
'
'Example:
'assertThat(foo, is(aString()))
'
'@param matcher {Object<Matcher>} A Matcher
'@return {Object<Matcher>} A Matcher
function is (matcher as Object) as Object
    return matcher
end function


'Creates a matcher that wraps an existing matcher, but inverts the logic by which it will match.
'
'Example:
'assertThat(foo, isNot(aString()))
'
'@param matcher {Object<Matcher>} A Matcher
'@return {Object<Matcher>} A Matcher
function isNot (matcher as Object) as Object
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

    matcher.arrayOfMatchers = arrayOfMatchers

    matcher.doMatch = function (target as Dynamic)
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

    matcher.arrayOfMatchers = arrayOfMatchers

    matcher.doMatch = function (target as Dynamic)
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

    matcher.arrayOfMatchers = arrayOfMatchers

    matcher.doMatch = function (target as Dynamic)
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

    return matcher
end function

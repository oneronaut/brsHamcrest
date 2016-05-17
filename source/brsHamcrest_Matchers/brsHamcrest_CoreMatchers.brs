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
            return (m.doMatchOrig(target) = False)
        end function

        retVal = newMatcher
    else
        HamcrestError("Type Mismatch: Expected a Matcher and encountered a ";type(matcher))
    end if
    return retVal
end function


'Creates a matcher that wraps an array of existing matchers, only passing if all Matchers are positive.
'
'Example:
'assertThat(foo, is(allOf([aString(), inCollection(bar)])))
'
'@param matcher {Object<Matcher>} A Matcher
'@return {Object<Matcher>} A Matcher
function allOf (arrayOfMatchers as Object) as Object
    matcher = BaseMatcher()

    matcher.doMatch = function (target as Dynamic) {
        result = false
        if (type(arrayOfMatchers) = "roArray")
            failure = false
            for each matcher in arrayOfMatchers
                if (matcher.CLASS_TYPE = "Matcher")
                    failure = (NOT matcher.doMatch(target))
                else
                    HamcrestError("Type Mismatch: Expected a Matcher and encountered a ";type(matcher))
                end if
            end for
            result = (NOT failure)
        else
            HamcrestError("Type Mismatch: Expected an Array and encountered a ";type(arrayOfMatchers))
        end if
        return result
    }

    return matcher
end function


'TODO'
' assertThat(foo, is(anyOf([matcher1, matcher2, ...])))
function anyOf (arrayOfMatchers as Object) as Object

end function


'TODO'
' assertThat(foo, is(noneOf([matcher1, matcher2, ...])))
function noneOf(arrayOfMatchers as Object) as Object

end function

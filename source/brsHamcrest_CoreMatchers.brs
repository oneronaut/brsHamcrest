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
    end if
    return retVal
end function

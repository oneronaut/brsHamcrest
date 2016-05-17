' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################
'                 Copyright (c) 2016 Benjamin Hill


'Shortcut to assertThat, designed for readability when using brstest
'
'Example for brstest:
't.assertTrue(that(foo, is(aString())))
'
'@param target {Dynamic} the target thing to assert against
'@param matcher {Object<Matcher>} the Matcher to apply to the target object
'@return {Boolean} result of the Matcher testing against the target object
function that(target as Dynamic, matcher as Object) as Boolean
    return assertThat(target, matcher)
end function


'Asserts that the given thing matches the given Matcher
'
'Example:
'success = assertThat(foo, is(aString()))
'
'@param target {Dynamic} the target thing to assert against
'@param matcher {Object<Matcher>} the Matcher to apply to the target object
'@return {Boolean} result of the Matcher testing against the target object
function assertThat(target as Dynamic, matcher as Object) as Boolean
    result = false
    if (matcher.CLASS_TYPE = "Matcher")
        result = matcher.doMatch(target)
    else
        HamcrestError("Type Mismatch: A Matcher must be specified")
    end if
    return result
end function

' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################
'                 Copyright (c) 2016 Benjamin Hill


'Matcher to test the given number is close to a value, within the given delta
'
'Example:
'assertThat(foo, is(closeTo(bar, delta)))
'
'@param value {Float} The value to aim for
'@param delta {Float} The variance allowed
'@return {Object<Matcher>} A Matcher
function closeTo (value as Float, delta as Float) as Object
    matcher = BaseMatcher()

    matcher.value = value
    matcher.delta = delta

    matcher.doMatch = function (target as Dynamic) as Boolean
        return (target >= m.value - m.delta AND target <= m.value + m.delta)
    end function

    return matcher
end function


'Matcher to test the given number is greater than a value
'
'Example:
'assertThat(foo, is(greaterThan(bar)))
'
'@param value {Float} The value to compare with
'@return {Object<Matcher>} A Matcher
function greaterThan (value as Float) as Object
    matcher = BaseMatcher()

    matcher.value = value

    matcher.doMatch = function (target as Dynamic) as Boolean
        return (target > m.value)
    end function

    return matcher
end function


'Matcher to test the given number is greater than or equal to a value
'
'Example:
'assertThat(foo, is(greaterThanOrEqualTo(bar)))
'
'@param value {Float} The value to compare with
'@return {Object<Matcher>} A Matcher
function greaterThanOrEqualTo (value as Float) as Object
    matcher = BaseMatcher()

    matcher.value = value

    matcher.doMatch = function (target as Dynamic) as Boolean
        return (target >= m.value)
    end function

    return matcher
end function


'Matcher to test the given number is less than to a value
'
'Example:
'assertThat(foo, is(lessThan(bar)))
'
'@param value {Float} The value to compare with
'@return {Object<Matcher>} A Matcher
function lessThan (value as Float) as Object
    matcher = BaseMatcher()

    matcher.value = value

    matcher.doMatch = function (target as Dynamic) as Boolean
        return (target < m.value)
    end function

    return matcher
end function


'Matcher to test the given number is less than or equal to a value
'
'Example:
'assertThat(foo, is(lessThanOrEqualTo(bar)))
'
'@param value {Float} The value to compare with
'@return {Object<Matcher>} A Matcher
function lessThanOrEqualTo (value as Float) as Object
    matcher = BaseMatcher()

    matcher.value = value

    matcher.doMatch = function (target as Dynamic) as Boolean
        return (target <= m.value)
    end function

    return matcher
end function
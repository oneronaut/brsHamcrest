' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################
'                 Copyright (c) 2016 Benjamin Hill


'Matcher to test a value contains a given String
'
'Example:
'assertThat(foo, containsString(bar))
'
'@param value {String} String to find
'@return {Object<Matcher>} A Matcher
function containsString (value as String) as Object
    matcher = BaseMatcher()

    matcher.value = value

    matcher.doMatch = function (target as String) as Boolean
        return (target.Instr(m.value) <> -1)
    end function

    return matcher
end function


'Matcher to test a value contains all strings in a given array
'
'Example:
'assertThat(foo, containsStrings(["string1", "string2", ...]))
'
'@param value {Object<Array>} Array of Strings to find
'@return {Object<Matcher>} A Matcher
function containsStrings (arrayOfStrings as Object) as Object
    matcher = BaseMatcher()

    matcher.stringArray = arrayOfStrings

    matcher.doMatch = function (target as String) as Boolean
        for each s in m.stringArray
            if (NOT containsString(s).doMatch(target))
                return false
            end if
        end for

        return true
    end function

    return matcher
end function


'Matcher to test a value contains all strings in a given array in the order given in the array
'
'Example:
'assertThat(foo, containsStringsInOrder(["string1", "string2", ...]))
'
'@param value {Object<Array>} Array of Strings to find in order
'@return {Object<Matcher>} A Matcher
function containsStringsInOrder (arrayOfStrings as Object) as Object
    matcher = BaseMatcher()

    matcher.stringArray = arrayOfStrings

    matcher.doMatch = function (target as String) as Boolean
        failure = false

        lastPos = 0

        for each s in m.stringArray
            position = Instr(1, target, s)
            if (position > lastPos)
                lastPos = position
            else
                failure = true
            end if
            if failure then exit for
        end for

        if (lastPos = 0) then failure = true

        return (NOT failure)
    end function

    return matcher
end function


'Matcher to test a value starts with the given string
'
'Example:
'assertThat(foo, startsWithString("bar"))
'
'@param value {Object<Array>} String to match
'@return {Object<Matcher>} A Matcher
function startsWithString (value as String) as Object
    matcher = BaseMatcher()

    matcher.beginStr = value

    matcher.doMatch = function (target as String) as Boolean
        return (target.InStr(m.beginStr) = 0)
    end function

    return matcher
end function


'Matcher to test a value ends with the given string
'
'Example:
'assertThat(foo, endsWithString("bar"))
'
'@param value {Object<Array>} String to match
'@return {Object<Matcher>} A Matcher
function endsWithString (value as String) as Object
    matcher = BaseMatcher()

    matcher.endStr = value

    matcher.doMatch = function (target as String) as Boolean
        return (target.Right(m.endStr.Len()) = m.endStr)
    end function

    return matcher
end function


'Matcher to test a value is empty (whitespace counts as empty)
'
'Example:
'assertThat(foo, is(anEmptyString()))
'
'@param value {Object<Array>} String to match
'@return {Object<Matcher>} A Matcher
function anEmptyString () as Object
    matcher = BaseMatcher()

    matcher.doMatch = function (target as String) as Boolean
        return (target.Trim() = "")
    end function

    return matcher
end function

' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


'Matcher to test a value contains a given String
'
'Example:
'assertThat(foo, containsString(bar))
'
'@param value {String} String to find
'@return {Object<Matcher>} A Matcher
function containsString (value as String) as Object
    matcher = BaseMatcher()

    matcher.append({
        value: value

        doMatch: function (target as Dynamic) as Boolean
            if AssertThat(target, is(aString()))
                return (target.Instr(m.value) <> -1)
            else
                return false
            end if
        end function
    })

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

    matcher.append({
        stringArray: arrayOfStrings

        doMatch: function (target as Dynamic) as Boolean
            if AssertThat(target, is(aString()))
                for each s in m.stringArray
                    if (NOT containsString(s).doMatch(target))
                        return false
                    end if
                end for

                return true
            else
                return false
            end if
        end function
    })

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

    matcher.append({
        stringArray: arrayOfStrings

        doMatch: function (target as Dynamic) as Boolean
            if AssertThat(target, is(aString()))
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
            else
                return false
            end if
        end function
    })

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

    matcher.append({
        beginStr: value

        doMatch: function (target as Dynamic) as Boolean
            if AssertThat(target, is(aString()))
                return (target.InStr(m.beginStr) = 0)
            else
                return false
            end if
        end function
    })

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

    matcher.append({
        endStr: value

        doMatch: function (target as Dynamic) as Boolean
            if AssertThat(target, is(aString()))
                return (target.Right(m.endStr.Len()) = m.endStr)
            else
                return false
            end if
        end function
    })

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

    matcher.append({

        doMatch: function (target as Dynamic) as Boolean
            if AssertThat(target, is(aString()))
                return (target.Trim() = "")
            else
                return false
            end if
        end function
    })

    return matcher
end function

' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


'Matcher to test the type is an Array
'
'Example:
'assertThat(foo, is(aArray()))
'
'@return {Object<Matcher>} A Matcher to match on the Array type
function aArray () as Object
    matcher = BaseMatcher()

    matcher.append({

        doMatch: function (target as Dynamic) as Boolean
            return type(target) = "roArray"
        end function
    })

    return matcher
end function

'A grammatically correct shortcut to the Array type Matcher
'
'Example:
'assertThat(foo, is(anArray()))
'
'@return {Object<Matcher>} A Matcher to match on the Array type
function anArray () as Object
    return aArray()
end function


'Matcher to test the type is an Associative Array
'
'Example:
'assertThat(foo, is(aAssociativeArray()))
'
'@return {Object<Matcher>} A Matcher to match on the Associative Array type
function aAssociativeArray () as Object
    matcher = BaseMatcher()

    matcher.append({

        doMatch: function (target as Dynamic) as Boolean
            return type(target) = "roAssociativeArray"
        end function
    })

    return matcher
end function


'A grammatically correct shortcut to the Associative Array type Matcher
'
'Example:
'assertThat(foo, is(anAssociativeArray()))
'
'@return {Object<Matcher>} A Matcher to match on the Associative Array type
function anAssociativeArray () as Object
    return aAssociativeArray()
end function


'Matcher to test the type is a Boolean
'
'Example:
'assertThat(foo, is(aBoolean()))
'
'@return {Object<Matcher>} A Matcher to match on the Boolean type
function aBoolean () as Object
    matcher = BaseMatcher()

    matcher.append({

        doMatch: function (target as Dynamic) as Boolean
            return type(target) = "Boolean" OR type(target) = "roBoolean"
        end function
    })

    return matcher
end function

'Matcher to test the type is a Double
'
'Example:
'assertThat(foo, is(aDouble()))
'
'@return {Object<Matcher>} A Matcher to match on the Double type
function aDouble () as Object
    matcher = BaseMatcher()

    matcher.append({

        doMatch: function (target as Dynamic) as Boolean
            return type(target) = "Double" OR type(target) = "roIntrinsicDouble" OR type(target) = "roDouble"
        end function
    })

    return matcher
end function


'Matcher to test the type is a Float
'
'Example:
'assertThat(foo, is(aFloat()))
'
'@return {Object<Matcher>} A Matcher to match on the Float type
function aFloat () as Object
    matcher = BaseMatcher()

    matcher.append({

        doMatch: function (target as Dynamic) as Boolean
            return type(target) = "Float" OR type(target) = "roFloat"
        end function
    })

    return matcher
end function


'Matcher to test the type is a Function
'
'Example:
'assertThat(foo, is(aFunction()))
'
'@return {Object<Matcher>} A Matcher to match on the Function type
function aFunction () as Object
    matcher = BaseMatcher()

    matcher.append({

        doMatch: function (target as Dynamic) as Boolean
            return type(target) = "Function" OR type(target) = "roFunction"
        end function
    })

    return matcher
end function


'Matcher to test the type is an Integer
'
'Example:
'assertThat(foo, is(aInteger()))
'
'@return {Object<Matcher>} A Matcher to match on the Integer type
function aInteger () as Object
    matcher = BaseMatcher()

    matcher.append({

        doMatch: function (target as Dynamic) as Boolean
            return type(target) = "Integer" OR type(target) = "roInteger" OR type(target) = "roInt"
        end function
    })

    return matcher
end function


'A grammatically correct shortcut to the Integer type Matcher
'
'Example:
'assertThat(foo, is(anInteger()))
'
'@return {Object<Matcher>} A Matcher to match on the Integer type
function anInteger () as Object
    return aInteger()
end function


'Matcher to test the type is an Invalid
'
'Example:
'assertThat(foo, is(aInvalid()))
'
'@return {Object<Matcher>} A Matcher to match on the Invalid type
function aInvalid () as Object
    matcher = BaseMatcher()

    matcher.append({

        doMatch: function (target as Dynamic) as Boolean
            return type(target) = "Invalid" OR type(target) = "roInvalid"
        end function
    })

    return matcher
end function


'A grammatically correct shortcut to the Invalid type Matcher
'
'Example:
'assertThat(foo, is(anInvalid()))
'
'@return {Object<Matcher>} A Matcher to match on the Invalid type
function anInvalid () as Object
    return aInvalid()
end function


'Matcher to test the type is a LongInteger
'
'Example:
'assertThat(foo, is(aLongInteger()))
'
'@return {Object<Matcher>} A Matcher to match on the LongInteger type
function aLongInteger () as Object
    matcher = BaseMatcher()

    matcher.append({

        doMatch: function (target as Dynamic) as Boolean
            return type(target) = "LongInteger" OR type(target) = "roLongInteger"
        end function
    })

    return matcher
end function


'Matcher to test the type is one of the numeric types (Float/Double/Integer/LongInteger)
'
'Example:
'assertThat(foo, is(aNumber()))
'
'@return {Object<Matcher>} A Matcher to match on the LongInteger type
function aNumber () as Object
    matcher = BaseMatcher()

    matcher.append({

        doMatch: function (target as Dynamic) as Boolean
            return (aFloat().doMatch(target) OR aDouble().doMatch(target) OR aInteger().doMatch(target) OR aLongInteger().doMatch(target))
        end function
    })

    return matcher
end function


'Matcher to test the type is a String
'
'Example:
'assertThat(foo, is(aString()))
'
'@return {Object<Matcher>} A Matcher to match on the String type
function aString () as Object
    matcher = BaseMatcher()

    matcher.append({

        doMatch: function (target as Dynamic) as Boolean
            return type(target) = "String" OR type(target) = "roString"
        end function
    })

    return matcher
end function


'Matcher to test the type of any non-intrinsic object type
'
'Example:
'assertThat(foo, is(typeOf("roDateTime")))
'
'@param typeString {String} The type to check against
'@return {Object<Matcher>} A Matcher to match on the String type
function typeOf (typeString as String) as Object
    matcher = BaseMatcher()

    matcher.append({
        typeString: typeString

        doMatch: function (target as Dynamic) as Boolean
            return type(target) = m.typeString
        end function
    })

    return matcher
end function

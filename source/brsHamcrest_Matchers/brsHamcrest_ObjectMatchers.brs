' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


'Matcher to test that two references are using the same object instance
'
'Example:
'assertThat(foo, is(sameObjectAs(bar)))
'
'@param value {Object} The object to compare against
'@return {Object<Matcher>} A Matcher
function sameObjectAs (value as Object) as Object
    matcher = BaseMatcher()

    matcher.append({
        value: value

        doMatch: function (target as Dynamic) as Boolean
            result = false
            if (HasInterface(target, "ifAssociativeArray") AND HasInterface(m.value, "ifAssociativeArray"))
                result = m._isSameObject(target, m.value)
            else if (HasInterface(target, "ifArray") AND HasInterface(m.value, "ifArray"))
                targetObj = {}
                target.push(targetObj)
                valueObj = m.value[m.value.count()-1]
                if HasInterface(valueObj, "ifAssociativeArray") AND m._isSameObject(targetObj, valueObj)
                    result = true
                end if
                target.pop()
            else
                result = False
            end if
            return result
        end function

        _isSameObject: function (target as dynamic, value as dynamic) as Boolean
            result = False
            deviceInfo = CreateObject("roDeviceInfo")
            uuidKey = "brsHamcrestUUID"
            uuidValue = deviceInfo.GetRandomUUID()
            target.AddReplace(uuidKey, uuidValue)
            if (value.Lookup(uuidKey) = uuidValue) then result = True
            target.Delete(uuidKey)
            value.Delete(uuidKey)
            return result
        end function
    })

    return matcher
end function


'Matcher to test that two object references are identically formed, even if they are not the same instance
'
'Example:
'assertThat(foo, is(IdenticalTo(bar)))
'
'@param value {Object} The object to compare against
'@return {Object<Matcher>} A Matcher
function identicalTo (value as Object) as Object
    matcher = BaseMatcher()

    matcher.append({
        value: value

        doMatch: function (target as Dynamic) as Boolean
            if (IsEnumerable(target) AND IsEnumerable(m.value))
                return coreDoMatch(target, m.value)
            else
                return False
            end if
        end function
    })

    return matcher
end function

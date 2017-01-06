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

    matcher.value = value

    matcher.doMatch = function (target as Dynamic) as Boolean
        if (HasInterface(target, "ifAssociativeArray") AND HasInterface(value, "ifAssociativeArray"))
            result = False
            deviceInfo = CreateObject("roDeviceInfo")
            uuidKey = "brsHamcrestUUID"
            uuidValue = deviceInfo.GetRandomUUID()
            target.AddReplace(uuidKey, uuidValue)
            if (value.Lookup(uuidKey) = uuidValue) then result = True
            target.Delete(uuidKey)
            value.Delete(uuidKey)
            return result
        else
            HamcrestError("Type Mismatch: Both target and value must be object types (implement ifAssociativeArray).")
            return False
        end if
    end function

    return matcher
end function

' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


'Access brsHamcrest's Options
function HamcrestOptions () as Object
    globalAA = GetGlobalAA()
    if (globalAA.brsHamcrestOptionsSingleton = Invalid)
        options = {
            'Error handling
            errors: {
                suppressErrors: false     'Suppress Error messages in the console
                stopOnErrors: true      'Cause a BrightScript STOP on an Error
            }

            'Test Mode
            testMode: false
        }
        globalAA.brsHamcrestOptionsSingleton = options
    end if
    return globalAA.brsHamcrestOptionsSingleton
end function


'Output an error message to the console, and cause a BrightScript STOP if option is set
'
'@param message {String} the error message to display
'@return {Dynamic} the error message as it was output to the console. Returns Invalid if nothing was output.
function HamcrestError (message as String) as Dynamic
    output = Invalid
    if (NOT HamcrestOptions().errors.suppressErrors)
        output = "[brsHamcrest] " + message
        if (NOT HamcrestOptions().testMode)
            print output
            if (HamcrestOptions().errors.stopOnErrors) then stop
        end if
    end if
    return output
end function


'Determine if an Object has a given Interface
'
'@param obj {Object} the Object to check for an Interface
'@param interfaceName {String} the name of the Interface (Eg. 'ifEnum')
'@return {Boolean} if the Object has the given Interface
function HasInterface (obj as Dynamic, interfaceName as String) as Boolean
    return (GetInterface(obj, interfaceName) <> Invalid)
end function


'Determine if an Object is enumerable
'
'@param obj {Object} the Object to check for enumerability
function IsEnumerable (obj as Dynamic) as Boolean
    return HasInterface(obj, "ifEnum")
end function


'Compare two objects are identical in contents, but are not the same object.
'
'@param target {Dynamic} the target to compare
'@param comparison {Dynamic} the comparison to compare against
'@return {Boolean} true if the target and comparison are identical
function CoreDoMatch (target as Dynamic, comparison as Dynamic) as Boolean
    targetType = type(target)
    comparisonType = type(comparison)

    if (targetType = comparisonType)

        if (targetType = "roArray")
            if (target.count() = comparison.count())
                for i=0 to target.count()-1 Step 1
                    if (CoreDoMatch(target[i], comparison[i]) = false) return false
                end for
            else
                return false
            end if
        else if (targetType = "roAssociativeArray")
            targetItems = target.items()
            comparisonItems = comparison.items()
            targetItemCount = targetItems.Count()
            if (targetItemCount = comparisonItems.Count())

                for i=0 to targetItemCount-1 step 1
                    if (targetItems[i].key <> comparisonItems[i].key)
                        return false
                    else
                        if (CoreDoMatch(targetItems[i].value, comparisonItems[i].value) = false) return false
                    end if
                end for
            else
                return false
            end if

        else if (targetType = "roBoolean" OR targetType = "roDouble" OR targetType = "roFloat" OR targetType = "roInteger" OR targetType = "roLongInteger" OR targetType = "roString")
            return (target = comparison)

        else if (targetType = "roFunction")
            return (target.toStr() = comparison.toStr())

        else
            return (targetType = comparisonType)
        end if
    else
        return false
    end if

    return true
end function

'Validate that a given object as a Matcher
'
'@param obj {Dynamic} the object to validate
function IsMatcher (obj as Dynamic) as Boolean
    if (type(obj) = "roAssociativeArray")
        'Ensure the BaseMatcher methods are present
        knownBaseMatcher = BaseMatcher()
        for each func in knownBaseMatcher.Keys()
            if (NOT obj.DoesExist(func)) then return false
        end for
        return true
    else
        return false
    end if
end function

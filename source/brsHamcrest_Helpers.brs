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

'Stop code execution and display an error message
'
'@param message {String} the error message to display
'@return {String} the error message as it was output to the console. Returns Invalid if nothing was output.
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

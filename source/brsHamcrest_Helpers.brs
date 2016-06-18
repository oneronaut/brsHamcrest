' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################
'                 Copyright (c) 2016 Benjamin Hill


'Access brsHamcrest's Options
function HamcrestOptions () as Object
    options = {
        'Error handling
        errors: {
            silentErrors: false     'Suppress Error messages in the console
            stopOnErrors: true      'Cause a BrightScript STOP on an Error
        }
    }
    return options
end function

'Stop code execution and display an error message
'
'@param message {String} the error message to display
function HamcrestError (message as String) as Void
    if (NOT HamcrestOptions().errors.silentErrors)
        if (message <> Invalid) then print "[brsHamcrest] " + message
        if (HamcrestOptions().errors.stopOnErrors) then stop
    end if
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
function isEnumerable (obj as Dynamic) as Boolean
    return HasInterface(obj, "ifEnum")
end function

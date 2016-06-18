' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################
'                 Copyright (c) 2016 Benjamin Hill


'Stop code execution and display an error message
'
'@param message {String} the error message to display
function HamcrestError (message as String) as Void
    if (message <> Invalid) then print "[brsHamcrest] " + message
    'stop
end function

function HasInterface (obj as Dynamic, interfaceName as String) as Boolean
    return (GetInterface(obj, interfaceName) <> Invalid)
end function

function isEnumerable (obj as Dynamic) as Boolean
    return HasInterface(obj, "ifEnum")
end function

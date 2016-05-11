' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################
'                 Copyright (c) 2016 Benjamin Hill


'Stop code execution and display an error message
'
'@param message {String} the error message to display
function HamcrestError (message as String) as Void
    if (message <> Invalid) then print "[brsHamcrest] " + message
    stop
end function

' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


'Base Matcher class that all Matchers should inherit from
'
'@return {Object<Matcher>} A Base Matcher class
function BaseMatcher () as Object
    matcher = {
        CLASS_TYPE: "Matcher"

        'Base Matcher class that all Matchers should inherit from
        '
        '@param target {Dynamic} The thing to perform the match on
        '@return {Object<Matcher>} A Base Matcher class
        doMatch: function (target as Dynamic) as Boolean
            HamcrestError("Error: BaseMatcher doMatch() method has not been overridden.")
            return False
        end function
    }

    return matcher
end function

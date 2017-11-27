' #################################################################
' ###   brsHamcrest   ###   github.com/imbenjamin/brsHamcrest   ###
' #################################################################


'Base Matcher class that all Matchers should inherit from
'
'@return {Object<Matcher>} A Base Matcher class
function BaseMatcher () as Object
    matcher = {
        CLASS_TYPE: "Matcher"

        'compare the target with criteria that are specific to the matcher implementation
        '
        '@param target {Dynamic} The thing to perform the match on
        '@return {Boolean} true if the specific match is successful
        doMatch: function (target as Dynamic) as Boolean
            HamcrestError("Error: BaseMatcher doMatch() method has not been overridden.")
            return False
        end function


        'compare the target matchers criteria to this matchers criteria
        '
        '@param targetMatcher {Dynamic} The matcher to perform the match on
        '@return {Boolean} true if the matched criteria are identical
        isSameMatch: function (targetMatcher as Dynamic) as Boolean
            return equalTo(m).doMatch(targetMatcher)
        end function
    }

    return matcher
end function

hook global BufCreate .*\.(j|ijs|ijx)$ %{
    set-option buffer filetype j
}

hook global WinSetOption filetype=j %{
    require-module jlang
    set-option buffer comment_line 'NB.'
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window jlang-.+ }
}

hook -group jlang-highlight global WinSetOption filetype=j %{
    add-highlighter window/jlang ref jlang
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/jlang }
}

provide-module jlang %{

add-highlighter shared/jlang regions
add-highlighter shared/jlang/code default-region group

# Strings
add-highlighter shared/jlang/string region \' \' group
add-highlighter shared/jlang/string/ fill string

# Keywords
add-highlighter shared/jlang/code/ regex \b(if|do|else|elseif|for|select|case|fcase|assert|break|continue|while|whilst|return|throw|try|catch|catchd|catcht|verb|monad|dyad)\b 0:keyword

# Comments
add-highlighter shared/jlang/comment region 'NB.' '$' fill comment
add-highlighter shared/jlang/shebang region '^#!' '$' fill comment

# Constants
add-highlighter shared/jlang/code/ regex '\b(?<! \.)(_\.\d+|_?\d+\.?\d*)(?![.:\w])' 0:value
add-highlighter shared/jlang/code/ regex \b(_?\d+\.?\d*)(b)(_?\w*\.?\w*)(?![.:\w]) 0:value
add-highlighter shared/jlang/code/ regex \b(_?\d+\.?\d*)(ar|ad|[ejprx])(_?\d*\.?\w*)(?![.:\w]) 0:value

# Operators
add-highlighter shared/jlang/code/ regex '=[.:]' 0:operator

add-highlighter shared/jlang/code/ regex \b(_\.|a\.|a:)(?![.:]) 0:operator
add-highlighter shared/jlang/code/ regex ((\b_?[1-9]:)|(\b0:)|(\{::))(?![.:]) 0:operator
add-highlighter shared/jlang/code/ regex \b((p\.\.)|([AcCeEiIjLopruv]\.)|([ipqsux]:))(?![.:]) 0:operator
add-highlighter shared/jlang/code/ regex \b(([bfM]\.))(?![.:]) 0:operator
add-highlighter shared/jlang/code/ regex (([/\\]\.)|([~/\\\}]))(?![.:]) 0:operator
add-highlighter shared/jlang/code/ regex \b((H\.)|([LS]:))(?![.:]) 0:operator
add-highlighter shared/jlang/code/ regex '((&\.:)|([&@!;]\.)|([&@!`^]:)|([&@`"]))(?![.:])' 0:operator
add-highlighter shared/jlang/code/ regex (?<=\s)([:][.:]|[.:])(?![.:]) 0:operator

## TODO: Fucking curly braces
add-highlighter shared/jlang/code/ regex '([<>\+\*\-%$|#,^~"?]\.)(?![.:])' 0:operator
add-highlighter shared/jlang/code/ regex '([<>\+\*\-%$|#,;~"_/\\\[]:)(?![.:])' 0:operator
add-highlighter shared/jlang/code/ regex '([<>\+\*\-%$|#,!;^=?\[\]])(?![.:])' 0:operator
}

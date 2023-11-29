hook global BufCreate .*\.a68$ %{
    set-option buffer filetype a68
}

hook global WinSetOption filetype=a68 %{
    require-module a68
    set-option buffer comment_block_begin '#'
    set-option buffer comment_block_end '#'
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window a68-.+ }
}

hook -group a68-highlight global WinSetOption filetype=a68 %{
    add-highlighter window/a68 ref a68
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/a68 }
}

provide-module a68 %{

add-highlighter shared/a68 regions
add-highlighter shared/a68/code default-region group

# Strings and characters
add-highlighter shared/a68/string region '"' '"' group
add-highlighter shared/a68/string/ fill string

# Formats
add-highlighter shared/a68/format region '\$' '\$' regions
add-highlighter shared/a68/format/main default-region fill meta
add-highlighter shared/a68/format/collateral region -recurse \( \( \) ref a68
add-highlighter shared/a68/format/string region '"' '"' ref a68/string

# Comments
add-highlighter shared/a68/comment-hash region '#' '#' fill comment
add-highlighter shared/a68/comment-co region '\bCO\b' '\bCO\b' fill comment
add-highlighter shared/a68/comment-comment region '\bCOMMENT\b' '\bCOMMENT\b' fill comment

# Constants
add-highlighter shared/a68/code/ regex \b(2r[01]+|4r[0-3]+|8r[0-7]+|16r[0-9a-f]+|[0-9]+)\b 0:value

# CAPS are all keywords by default
add-highlighter shared/a68/code/ regex \b([A-Z]+)\b 0:keyword

# Keywords that are also values
add-highlighter shared/a68/code/ regex \b(TRUE|FALSE|EMPTY|NIL)\b 0:value

# Keywords that are also types
add-highlighter shared/a68/code/ regex \b(LONG|REAL|INT|BITS|SHORT|STRING|CHAR|BOOL|BYTES|COMPL|COMPLEX|FLEX|FORMAT|FILE|PIPE|CHANNEL|SEMA|STRUCT|REF|UNION|PROC|SOUND)\b 0:type

# Operators
# add-highlighter shared/a68/code/ regex '(?:\+|-|\*|/|%|=|<|>|&|\||\^|~|\?|!|:)' 0:operator

}

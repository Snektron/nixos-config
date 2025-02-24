hook global BufCreate .*\.fut$ %{
    set-option buffer filetype futhark
}

hook global WinSetOption filetype=futhark %{
    require-module futhark
    set-option buffer comment_line '--'
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window futhark-.+ }
}

hook -group futhark-highlight global WinSetOption filetype=futhark %{
    add-highlighter window/futhark ref futhark
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/futhark }
}

provide-module futhark %{

add-highlighter shared/futhark regions
add-highlighter shared/futhark/code default-region group

add-highlighter shared/futhark/code/char regex "'([^\\]|\\(.|x[0-9a-fA-F]{2}|u\{[0-9a-fA-F]{1,6}\}))'" 0:value

# Comments
add-highlighter shared/futhark/comment region '--' '$' fill comment

# Attributes
add-highlighter shared/futhark/code/ regex '#\[[^\]]*\]' 0:meta

# Type parameters
add-highlighter shared/futhark/code/ regex "(?:'[~^]?)[_A-Za-z]\w*\b" 0:meta

# Constants
add-highlighter shared/futhark/code/ regex \b(?:true|false|[0-9][_0-9]*(?:\.[0-9][_0-9]*|(?:\.[0-9][_0-9]*)?E[\+\-][_0-9]+)(?:f(?:32|64))?|(?:0x[_0-9a-fA-F]+|0b[_01]+|[0-9][_0-9]*)(?:(?:i|u|f)(?:8|16|32|64))?)\b 0:value

# Types
add-highlighter shared/futhark/code/ regex \b(?:u8|u16|u32|u64|i8|i16|i32|i64|f32|f64|bool)\b 0:type

# Keywords
add-highlighter shared/futhark/code/ regex \b(?:assert|case|do|else|def|entry|for|if|import|include|in|let|local|loop|match|module|open|then|type|unsafe|val|while|with)\b 0:keyword

# Operators
add-highlighter shared/futhark/code/ regex '(?:\+|-|\*|/|%|=|<|>|&|\||\^|~|\?|!)' 0:operator

}

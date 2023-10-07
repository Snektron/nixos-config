hook global BufCreate .*\.spvasm %{
    set-option buffer filetype spirv
}

hook global WinSetOption filetype=spirv %{
    require-module spirv
    set-option buffer comment_line ';'
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window spirv-.+ }
}

hook -group spirv-highlight global WinSetOption filetype=spirv %{
    add-highlighter window/spirv ref spirv
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/spirv }
}

provide-module spirv %{

add-highlighter shared/spirv regions
add-highlighter shared/spirv/code default-region group

# Strings
add-highlighter shared/spirv/string region '"' (?<!\\)(\\\\)*" group
add-highlighter shared/spirv/string/ fill string
add-highlighter shared/spirv/string/ regex '(?:\\\\|\\")' 0:meta

# Comments
add-highlighter shared/spirv/comment region ';' '$' fill comment

# Constants
add-highlighter shared/spirv/code/ regex '(0x[0-9a-fA-F]+|[0-9]+|0b[01]+|0o[0-7]+)\b' 0:value

# IDs
add-highlighter shared/spirv/code/ regex '(?:%[A-Za-z0-9_]+\b)' 0:meta

# Instructions
add-highlighter shared/spirv/code/ regex '(?:Op[A-Z][A-Za-z0-9]*\b)' 0:keyword
add-highlighter shared/spirv/code/ regex '(?:OpType[A-Z][A-Za-z0-9]*\b)' 0:type

}

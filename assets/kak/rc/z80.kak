hook global BufCreate .*\.z80$ %{
    set-option buffer filetype z80
}

hook global WinSetOption filetype=z80 %{
    require-module z80
    set-option buffer comment_line ';'
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window z80-.+ }
}

hook -group z80-highlight global WinSetOption filetype=z80 %{
    add-highlighter window/z80 ref z80
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/z80 }
}

provide-module z80 %{

add-highlighter shared/z80 regions
add-highlighter shared/z80/code default-region group

# Strings and characters
add-highlighter shared/z80/string region '"' (?<!\\)(\\\\)*" group
add-highlighter shared/z80/string/ fill string
add-highlighter shared/z80/string/ regex '(?:\\0|\\a|\\b|\\t|\\n|\\b|\\f|\\r|\\\\|\\"|\\'')' 0:meta

add-highlighter shared/z80/character region (?<!af)' (?<!\\)(\\\\)*' group
add-highlighter shared/z80/character/ fill string
add-highlighter shared/z80/character/ regex '(?:\\0|\\a|\\b|\\t|\\n|\\b|\\f|\\r|\\\\|\\"|\\'')' 0:meta

add-highlighter shared/z80/comment region ';' '$' fill comment

# Constants
add-highlighter shared/z80/code/ regex \b(0x[0-9a-fA-F]+|[0-9]+|0b[01]+|0o[0-7]+)\b 0:value

# Labels
add-highlighter shared/z80/code/ regex ^\h*(\.?[A-Za-z0-9_]+): 0:operator

# Directives
add-highlighter shared/z80/code/ regex ((^|\s+)[.#](area|ascii|asciiz|asciip|block|db|dw|define|equ|equate|export|fill|if|ifdef|ifndef|else|elif|elseif|endif|end|import|include|incbin|list|macro|endmacro|nolist|org|printf|!))\b 0:type

# Registers
add-highlighter shared/z80/code/ regex \b(af'|(af|bc|de|hl|ix|iy|sp|pc|i|r|ixh|ixl|iyh|iyl|a|b|c|d|e|f|h|l)\b) 0:variable

# Instructions
add-highlighter shared/z80/code/ regex (^|\\)\h*(adc|add|and|bit|call|ccf|cp|cpd|cpdr|cpi|cpir|cpl|daa|dec|di|djnz|ei|ex|exx|halt|im|in|inc|ind|indr|ini|inir|jp|jr|ld|ldd|lddr|ldi|ldir|neg|nop|or|otdr|otir|out|outd|outi|pop|push|res|ret|reti|retn|rl|rla|rlc|rlca|rld|rr|rra|rrc|rrca|rrd|rst|sbc|scf|set|sla|sll|sra|srl|sub|xor)\b 2:keyword
}

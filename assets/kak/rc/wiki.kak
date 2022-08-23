# Custom wiki tools and syntax highlighting
# Based on markdown, with a custom extension to make it simpler.
# ---
# This wiki uses .wiki as a file extension, and assumes that any repository containing
# such files is a wiki. This way we can hook our commands on the .wiki file, and assume
# that the current directory of the kakoune instance is the wiki repository root.
# The functionality of this module is mainly inspired by Zim.
# ---
# Hooks related to this module use the prefix wiki-

# TODO:
# highlighting:
# - @tags
# - dates?

# Detection
hook global BufCreate .*\.wiki$ %{
    set-option buffer filetype wiki
}

# Initialization
hook global WinSetOption filetype=wiki %{
    require-module wiki

    hook -once -always window WinSetOption filetype.* %{ remove-hooks window wiki-.+ }
}

hook -group wiki-load-languages global WinSetOption filetype=wiki %{
    hook -group wiki-load-languages window NormalIdle .* wiki-load-languages
    hook -group wiki-load-languages window InsertIdle .* wiki-load-languages
}

hook -group wiki-highlight global WinSetOption filetype=wiki %{
    add-highlighter window/wiki ref wiki
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/wiki }
}

provide-module wiki %§

add-highlighter shared/wiki regions
add-highlighter shared/wiki/inline default-region regions
add-highlighter shared/wiki/inline/text default-region group

evaluate-commands %sh{
    languages="
        awk c cabal clojure coffee cpp crystal css cucumber d diff dockerfile elixir erlang fish
        gas go haml haskell html ini java javascript json julia kak kickstart
        latex lisp lua makefile markdown moon objc ocaml perl pug python ragel
        ruby rust sass scala scss sh swift toml tupfile typescript yaml sql zig
    "
    for lang in ${languages}; do
        printf 'add-highlighter shared/wiki/%s region -match-capture ^(\h*)```\h*(%s\\b|\\{[.=]?%s\\})   ^(\h*)``` regions\n' "${lang}" "${lang}" "${lang}"
        printf 'add-highlighter shared/wiki/%s/ default-region fill meta\n' "${lang}"
        [ "${lang}" = kak ] && ref=kakrc || ref="${lang}"
        printf 'add-highlighter shared/wiki/%s/inner region \A```[^\\n]*\K (?=```) ref %s\n' "${lang}" "${ref}"
    done
}

add-highlighter shared/wiki/inline/text/ regex ^\h*([-*])\s 1:bullet
add-highlighter shared/wiki/inline/text/ regex ^\h*(\[[\sx]\])\s 1:meta
add-highlighter shared/wiki/inline/text/ regex ^\h*(TODO:|DONE:|WAIT(\(.*\))?:)\s 1:meta
add-highlighter shared/wiki/inline/text/ regex (?:\s|^)(@[a-zA-Z_0-9]+) 1:title

add-highlighter shared/wiki/codeblock region -match-capture \
    ^(\h*)```\h* \
    ^(\h*)```\h*$ \
    fill meta

add-highlighter shared/wiki/inline/url region -recurse \( ([a-z]+://|(mailto|magnet|xmpp):) (?!\\).(?=\))|\s fill link

add-highlighter shared/wiki/inline/code region -match-capture (`+) (`+) fill meta

# Setext-style header
add-highlighter shared/wiki/inline/text/ regex (\A|^\n)[^\n]+\n={2,}\h*\n\h*$ 0:title
add-highlighter shared/wiki/inline/text/ regex (\A|^\n)[^\n]+\n-{2,}\h*\n\h*$ 0:header

# Atx-style header
add-highlighter shared/wiki/inline/text/ regex ^#[^\n]* 0:header

# Bold
add-highlighter shared/wiki/inline/text/ regex (?<!\*)(\*([^\s*]|([^\s*](\n?[^\n*])*[^\s*]))\*)(?!\*) 1:+b
# Italics
add-highlighter shared/wiki/inline/text/ regex (?<!_)(_([^\s_]|([^\s_](\n?[^\n_])*[^\s_]))_)(?!_) 1:+i
# Quotations.
add-highlighter shared/wiki/inline/text/ regex ^\h*(>\h*)+ 0:comment

define-command -hidden wiki-load-languages %{
    evaluate-commands -draft %{ try %{
        execute-keys 'gtGbGls```\h*\{?[.=]?\K[^}\s]+<ret>'
        evaluate-commands -itersel %{ require-module %val{selection} }
    }}
}

define-command wiki-cycle-checkbox -docstring "Cycle a checkbox on the current line" %{
    try %{
        execute-keys -draft '<esc><space>;xs^\h*\[<space>\]<space><ret>;hhrx'
    } catch %{
        try %{
            execute-keys -draft '<esc><space>;xs^\h*\[x\]<space><ret>;hhr<space>'
        }
    }

    try %{
        execute-keys -draft '<esc><space>;xs^\h*TODO:<ret>sTODO<ret>cDONE'
    } catch %{
        try %{
            execute-keys -draft '<esc><space>;xs^\h*DONE:<ret>sDONE<ret>cTODO'
        }
    }
}

define-command wiki-insert-date -hidden %{
    execute-keys -draft %sh{
        DATE=$(date "+%A %d %b %Y")
        printf "%s\n" "i$DATE<esc>"
        printf "%s\n" "i<ret>$DATE<esc>h<a-h>r=o<esc>"
    }
}

define-command wiki-todo -docstring "Search for all TODOs" %{
    # TODO: It would be nice if this supported live updating.
    evaluate-commands "grep '^[ \t]*(\[ \]\s|TODO:|WAIT(\(.*?\))?:)'"
}

define-command wiki-journal-today -docstring "Open the journal entry for today" %{
    evaluate-commands %sh{
        if [ ! -d journal ]; then
            printf "%s\n" "fail journal not enabled"
            return
        fi
        read -r Y M D <<< "$(date '+%Y %m %d')"
        printf "%s\n" "edit journal/$Y/$M/$D.jnl.wiki"
    }
}

hook global -group wiki-journal-date BufNewFile .*\.jnl\.wiki wiki-insert-date

declare-user-mode wiki
map global wiki c ': wiki-cycle-checkbox<ret>' -docstring 'Cycle checkbox'
map global wiki d ': wiki-journal-today<ret>' -docstring 'Open journal for today'
map global wiki t ': wiki-todo<ret>' -docstring 'Show all TODOs'
define-command wiki -params 0 'enter-user-mode wiki' -docstring 'Wiki mode'

§

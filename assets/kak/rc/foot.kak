declare-option str foot_normal_cmd 'foot' # TODO: footclient
declare-option str foot_popup_cmd 'foot' # TODO: footclient
declare-option str foot_panel_cmd 'foot' # TODO: footclient
declare-option str-list foot_normal_flags
declare-option str-list foot_popup_flags '--app-id=popup'
declare-option str-list foot_panel_flags '--app-id=panel'

remove-hooks global foot-detection
hook -group foot-detection global ClientCreate '.*' %{
    trigger-user-hook "TERM=%val{client_env_TERM}"
}

define-command -override foot-integration-enable -docstring '
enable foot integration' %{
    remove-hooks global foot-integration
    hook -group foot-integration global User 'TERM=foot' %{
        define-command -override foot-terminal -params .. -shell-completion -docstring '
        foot-terminal <program> [arguments]:
        create a new terminal as a foot window' %{
            foot %opt{foot_normal_cmd} %opt{foot_normal_flags} %arg{@}
        }

        define-command -override foot-terminal-popup -params .. -shell-completion -docstring '
        foot-terminal-popup <program> [arguments]:
        create a new terminal as a foot window (with foot_popup_flags)' %{
            foot %opt{foot_popup_cmd} %opt{foot_popup_flags} %arg{@}
        }

        define-command -override foot-terminal-panel -params .. -shell-completion -docstring '
        foot-terminal-popup <program> [arguments]:
        create a new terminal as a foot window (with foot_panel_flags)' %{
            foot %opt{foot_panel_cmd} %opt{foot_panel_flags} %arg{@}
        }

        define-command -override -hidden foot -params .. -docstring '
        foot [flags] [options]:
        open foot' %{
            nop %sh{
                setsid "$@" < /dev/null > /dev/null 2>&1 &
            }
        }

        alias global terminal foot-terminal
        alias global terminal-popup foot-terminal-popup
        alias global terminal-panel foot-terminal-panel
        alias global popup foot-terminal-popup
        alias global panel foot-terminal-panel
    }
}

define-command -override foot-integration-disable -docstring '
disable foot integration' %{
    remove-hooks global foot-integration
}

foot-integration-enable

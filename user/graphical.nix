{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./headless.nix
    ../modules/home-manager/river.nix
    ../modules/home-manager/swaybg.nix
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    GDK_BACKEND = "wayland";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  home.packages = with pkgs; [
    bitwarden-desktop
    bluez
    ccls
    chromium
    corefonts
    dejavu_fonts
    drawio
    font-awesome_5
    gamemode
    gimp
    grim
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nsight-compute
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nsight-systems
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.pinball
    # inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.rocprof-compute-viewer
    meld
    montserrat
    moreutils
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    obsidian
    obs-studio
    pavucontrol
    qcad
    river-classic
    rivercarro
    roboto
    signal-desktop
    telegram-desktop
    transmission_4-qt
    wl-clipboard
    xdg-desktop-portal-gtk
    xdg-utils # xdg-open required for foot url thingy
  ];

  fonts.fontconfig.enable = true;

  programs.river = {
    enable = true;
    systemdIntegration = true;

    layoutGenerator = {
      command = "${pkgs.rivercarro}/bin/rivercarro -inner-gaps 2 -outer-gaps 2 -main-ratio 0.5 -per-tag";
    };

    bindings =
    let
      mod = "Mod4"; # Windows key
      pamixer = "${pkgs.pamixer}/bin/pamixer";
      playerctl = "${pkgs.playerctl}/bin/playerctl";
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      # TODO: Move to central lib
      pwr = base: exp: lib.foldl (x: _: x * base) 1 (lib.range 1 exp);
      allTags = (pwr 2 32) - 1;
      # TODO: Move to central lib
      concatAttrs = attrList: lib.fold (x: y: x // y) {} attrList;
      tagBinds = concatAttrs
        (map
          (i: let
            tags = pwr 2 (i - 1);
          in {
            "${mod} ${toString i}" = "set-focused-tags ${toString tags}";
            "${mod}+Shift ${toString i}" = "set-view-tags ${toString tags}";
            "${mod}+Control ${toString i}" = "toggle-focused-tags ${toString tags}";
            "${mod}+Shift+Control ${toString i}" = "toggle-view-tags ${toString tags}";
          })
          (lib.range 1 9));
      screenshot = pkgs.writeShellScript "screenshot" ''
        ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png
      '';
    in {
      normal = tagBinds // {
        "${mod} Return" = "spawn '${pkgs.foot}/bin/foot'"; # TODO: Find out why footclient prints a bunch of random stuff...
        "${mod} Q" = "close";
        "${mod} J" = "focus-view next";
        "${mod} K" = "focus-view previous";
        "${mod}+Shift J" = "swap next";
        "${mod}+Shift K" = "swap previous";
        "${mod} V" = "spawn '${pkgs.swaylock}/bin/swaylock'";

        "${mod}+Shift Return" = "zoom";

        "${mod} Z" = "focus-output next";
        "${mod}+Shift Z" = "send-to-output next";

        "${mod} Space" = "toggle-float";

        "${mod} F" = "toggle-fullscreen";
        "${mod} D" = "spawn '${pkgs.rofi}/bin/rofi -combi-modi drun,ssh -show combi -modi combi'";

        "${mod} H" = "send-layout-cmd rivercarro 'main-ratio -0.05'";
        "${mod} L" = "send-layout-cmd rivercarro 'main-ratio +0.05'";

        "${mod}+Shift H" = "send-layout-cmd rivercarro 'main-count +1'";
        "${mod}+Shift L" = "send-layout-cmd rivercarro 'main-count -1'";

        "${mod} Up" = "send-layout-cmd rivercarro 'main-location top'";
        "${mod} Right" = "send-layout-cmd rivercarro 'main-location right'";
        "${mod} Down" = "send-layout-cmd rivercarro 'main-location bottom'";
        "${mod} Left" = "send-layout-cmd rivercarro 'main-location left'";
        "${mod} M" = "send-layout-cmd rivercarro 'main-location monocle'";
        "${mod} W" = "send-layout-cmd rivercarro 'main-location-cycle left,monocle'";

        "None Print" = "spawn '${screenshot}'";

        "None XF86Eject" = "spawn 'eject -T'";

        "None XF86AudioRaiseVolume" = "spawn '${pamixer} -i 5'";
        "None XF86AudioLowerVolume" = "spawn '${pamixer} -d 5'";
        "None XF86AudioMute" = "spawn '${pamixer} --toggle-mute'";
        "None XF86AudioMicMute" = "spawn '${pamixer} --default-source --toggle-mute'";

        "None XF86AudioMedia" = "spawn '${playerctl} play-pause'";
        "None XF86AudioPlay" = "spawn '${playerctl} play-pause'";
        "None XF86AudioPause" = "spawn '${playerctl} play-pause'";
        "None XF86AudioPrev" = "spawn '${playerctl} previous'";
        "None XF86AudioNext" = "spawn '${playerctl} next'";

        "None XF86MonBrightnessUp" = "spawn '${brightnessctl} s 5%+'";
        "None XF86MonBrightnessDown" = "spawn '${brightnessctl} s 5%-'";
        "None XF86KbdBrightnessUp" = "spawn '${brightnessctl} -d asus::kbd_backlight s 5%+'";
        "None XF86KbdBrightnessDown" = "spawn '${brightnessctl} -d asus::kbd_backlight s 5%-'";

        "${mod} 0" = "set-focused-tags ${toString allTags}";
        "${mod}+Shift 0" = "set-view-tags ${toString allTags}";

        "${mod} F11" = "enter-mode passthrough";
      };
      pointer = {
        "${mod} BTN_LEFT" = "move-view";
        "${mod} BTN_RIGHT" = "resize-view";
      };
      passthrough = {
        "${mod} F11" = "enter-mode normal";
      };
    };

    config = {
      attachMode = "bottom";
      border = {
        color = {
          focused = "0xeaea00";
          unfocused = "0x484848";
        };
        width = 1;
      };
      cursor = {
        followFocus = "normal";
        hide = 5000;
      };
      repeat = {
        rate = 50;
        delay = 300;
      };
    };

    extraConfig = ''
      riverctl float-filter-add app-id 'float'
      riverctl float-filter-add app-id 'popup'
      riverctl rule-add ssd
      riverctl default-layout rivercarro
    '';
  };

  programs.git = {
    settings.diff.tool = "meld";
  };

  programs.ssh = {
    # Remote servers cannot deal with TERM=foot
    matchBlocks."*".setEnv = {
      TERM = "xterm-256color";
    };
  };

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "foot";
        font = "monospace:size=7, Noto Color Emoji:size=7";
        dpi-aware = "yes";
      };
      mouse.hide-when-typing = "yes";
      scrollback.lines = 65536;
      colors = {
        background = "181818";
        foreground = "dddddd";

        regular0 = "000000";
        regular1 = "cc0403";
        regular2 = "19cb00";
        regular3 = "cecb00";
        regular4 = "0d73cc";
        regular5 = "cb1ed1";
        regular6 = "0dcdcd";
        regular7 = "dddddd";

        bright0 = "767676";
        bright1 = "f2201f";
        bright2 = "23fd00";
        bright3 = "fffd00";
        bright4 = "1a8fff";
        bright5 = "14ffff";
        bright6 = "ffffff";
      };
    };
  };
  systemd.user.services.foot.Install.WantedBy = lib.mkForce [ "river-session.target" ];

  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        FirefoxHome = {
          Pocket = false;
          Snippets = false;
        };
        UserMessaging = {
          ExtensionRecommendation = false;
          SkipOnboarding = false;
        };
      };
    };
    profiles.robin = {
      id = 0; # default
      userChrome = ''
        @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"); /* set default namespace to XUL */
        .titlebar-spacer[type="pre-tabs"] {
          display: none !important;
        }
      '';
    };
  };

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.foot}/bin/foot";
    extraConfig = {
      modi = "drun,ssh,combi";
      separator-style = "dash";
      color-enabled = true;
    };
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "river-session.target";
    };
    settings = {
      main = {
        layer = "bottom";
        position = "bottom";
        height = 25;

        modules-left = [ "river/tags" ];
        modules-right = [ "tray" "network" "battery" "cpu" "memory" "pulseaudio" "clock" ];

        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };
        cpu = {
          format = "{}% ";
        };
        memory = {
          format = "{}% ";
        };
        tray = {
          spacing = 10;
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
      };
    };
    style = ../assets/waybar-style.css;
  };

  programs.swaybg = {
    enable = true;
    mode = "fill";
    systemdTarget = "river-session.target";
  };

  programs.swaylock = {
    enable = true;
    settings = {
      scaling = config.programs.swaybg.mode;
      image = "${config.programs.swaybg.image}";
      indicator-caps-lock = true;
      show-failed-attempts = true;
    };
  };

  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-bin;
    profiles.robin = {
      isDefault = true;
    };
    settings = {
      "privacy.donottrackheader.enabled" = true;
    };
  };

  programs.zed-editor = {
    enable = true;
  };

  services.mako = {
    enable = true;
    settings.default-timeout = 3000;
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "river-session.target";
  };

  programs.nix-index.enable = true;

  services.gpg-agent = {
    enable = false;
    pinentry.package = pkgs.pinentry-gtk2;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.numix-gtk-theme;
      name = "Numix";
    };
    cursorTheme = {
      package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.breeze-obsidian-cursor-theme;
      name = "Breeze_Obsidian";
    };
    iconTheme = {
      package = pkgs.numix-icon-theme-circle;
      name = "Numix-Circle-Light";
    };
  };

  # For good measure
  home.file.".icons/default".source = "${inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.breeze-obsidian-cursor-theme}/share/icons/Breeze_Obsidian";
}

{ inputs, lib, config, pkgs, ... }: {
  home.username = "robin";
  home.homeDirectory = "/home/robin";
  home.stateVersion = "22.11";

  home.sessionVariables = {
    EDITOR = "${pkgs.kakoune}/bin/kak";
  };

  # TODO: Trim these packages so that we dont get the X libraries for random bullshit
  home.packages = with pkgs; [
    acpi
    (aspellWithDicts (dicts: [dicts.en dicts.en-computers dicts.en-science]))
    bintools-unwrapped
    editorconfig-core-c
    fd
    fzf
    gnupg
    htop
    kak-lsp
    kakoune
    killall
    libqalculate
    libtree
    lm_sensors
    moreutils
    mutagen
    python3
    ripgrep
    unzip
    usbutils
    visidata
    zip
  ];

  xdg.enable = true;

  # Kakoune config files
  # The kakoune module is a bit too invasive, so just copy all the files in
  # assets/kak/ to the $XDG_CONFIG_HOME/kak/ manually.
  # TODO: Make it not use rofi in headless mode
  xdg.configFile."kak".source = ../assets/kak;

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;

    package = pkgs.gitFull;

    userName = "Robin Voetter";
    userEmail = lib.mkDefault "robin@voetter.nl";

    ignores = [ ".private" ".cache" "build" ".direnv" ".envrc" ];

    extraConfig = {
      core.autocrlf = false;
      pull.rebase = true;
      color.ui = true;

      gpg.format = "ssh";
      # Note: also enables SSH signing.
      # Should this be optional?
      commit.gpgSign = true;
      user.signingKey = "${../keys/yubikey}";
    };
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
      };
      "pythons.space" = {
        user = "robin";
        hostname = "pythons.space";
      };
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      tabs -4
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      set fish_greeting
      fish_vi_key_bindings
    '';
    shellAbbrs = {
      gs = "git status";
      gl = "git log --oneline --graph";
      ga = "git add";
      gd = "git diff";
      gdc = "git diff --cached";
      gf = "git fetch";
      gfa = "git fetch --all";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gc = "git commit";
      gcm = "git commit -m";
      gca = "git commit --amend --no-edit";
      gco = "git checkout";
      grc = "git rebase --continue";
    };
    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
          sha256 = "+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
        };
      }
      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "1a0bf6c66ce37bfb0b4b0d96d14e958445c21448";
          sha256 = "sha256-1Rx17Y/NgPQR4ibMnsZ/1UCnNbkx6vZz43IKfESxcCA=";
        };
      }
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nix-index.enable = true;

  services.gpg-agent = rec {
    defaultCacheTtl = 60 * 60 * 8;
    defaultCacheTtlSsh = defaultCacheTtl;
    maxCacheTtl = 60 * 60 * 8;
    maxCacheTtlSsh = maxCacheTtl;
    enableSshSupport = true;
    pinentryFlavor = lib.mkDefault "curses";
  };
}

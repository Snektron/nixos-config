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
    nix-output-monitor
    moreutils
    mutagen
    (python3.withPackages (ps: with ps; [ numpy ]))
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

  xdg.configFile."kak-lsp/kak-lsp.toml".text = ''
    [server]
    timeout = 1800

    [language.c_cpp]
    filetypes = ["c", "cpp"]
    roots = [".git", ".clangd", ".ccls"]
    command = "ccls" # We explicitly dont hardcode a path so that project-specific flakes can override the ccls
    args = ["--init={\"completion\":{\"detailedLabel\":false}}"]
  '';

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
    controlMaster = "auto";
    controlPersist = "60m";
    matchBlocks = let
      trustedHosts = {
        # VPS
        "pythons.space" = {};
        # Desktop
        "python".hostname = "192.168.178.100";
      };
      # git hosts. User is set to "git".
      gitHosts = {
        "github.com" = {};
      };
      setDefaults = defaults: hosts: builtins.mapAttrs (name: value: value // defaults) hosts;
    in (setDefaults { user = "robin"; forwardAgent = true; } trustedHosts)
    // (setDefaults { user = "git"; } gitHosts);
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

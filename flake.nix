{
  description = "Snektrons's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    nixos-vf2.url = "github:Snektron/nixos-vf2";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Note: Don't follow the upstream on nixos-vf2 to avoid triggering costly
    # risc-v rebuilds when bumping the main inputs.
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nixos-vf2, ... } @ inputs: {
    overlays.default = import ./overlays;

    nixosModules = import ./modules/nixos;

    nixosConfigurations = let
      mkSystem = nixpkgs: module: nixpkgs.lib.nixosSystem {
         modules = [
           module
           # This is separate because its shared with home-manager
           # If home-manager options defines these options also, some
           # asserts trigger in home-manager. But we want them to also
           # be applied if switching to a home without going through
           # nixos, so its handled specially.
          ./modules/nixpkgs-config.nix
         ];
         # Make sure to pass the right nixpkgs here
         specialArgs.inputs = {
           inherit nixpkgs;
           inherit self nixos-hardware home-manager nixos-vf2;
         };
      };
    in {
      lora = mkSystem nixpkgs ./hosts/lora;
      python = mkSystem nixpkgs ./hosts/python;
      # Use nixos-vf2's pinned nixpkgs here to keep the versions
      # in sync.
      rattlesnake = mkSystem nixos-vf2.inputs.nixpkgs ./hosts/rattlesnake;
      taipan = mkSystem nixpkgs ./hosts/taipan;
    };

    homeConfigurations = let
      mkHome = { system, userModule }: home-manager.lib.homeManagerConfiguration {
        modules = [
          userModule
          # See above comment on nixpkgs-config.nix
          ./modules/nixpkgs-config.nix
        ];
        pkgs = nixpkgs.outputs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs; };
      };
    in {
      lora = mkHome {
        system = "x86_64-linux";
        userModule = ./user/lora.nix;
      };
      python = mkHome {
        system = "x86_64-linux";
        userModule = ./user/python.nix;
      };
      headless = mkHome {
        system = "x86_64-linux";
        userModule = ./user/headless.nix;
      };
    };

    packages =
    let
      system = "x86_64-linux";
    in {
      ${system} = import ./packages {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      };
    };
  };
}

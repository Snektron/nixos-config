{
  description = "Snektrons's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager/release-23.11";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: {
    overlays.default = import ./overlays;

    nixosConfigurations = let
      mkSystem = module: nixpkgs.lib.nixosSystem {
         modules = [ module ];
         specialArgs = { inherit inputs; };
      };
    in {
      lora = mkSystem ./hosts/lora;
      python = mkSystem ./hosts/python;
    };

    homeConfigurations = let
      mkHome = { system, userModule }: home-manager.lib.homeManagerConfiguration {
        modules = [
          userModule
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
        pkgs = nixpkgs.outputs.legacyPackages.${system};
      };
    };
  };
}

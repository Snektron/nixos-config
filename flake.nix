{
  description = "Snektrons's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
  let
    nixpkgsConfig = {
      overlays = [
        inputs.self.overlays.default
      ];

      config = {
        allowUnfree = true;
        # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1119760100
        allowUnfreePredicate = (pkg: true);
      };
    };
  in {
    overlays.default = import ./overlays;

    nixosConfigurations = {
      lora = import ./hosts/lora {
        inherit inputs nixpkgsConfig;
      };
      python = import ./hosts/python {
        inherit inputs nixpkgsConfig;
      };
    };

    homeConfigurations = let
      mkUser = { system, userModule }: inputs.home-manager.lib.homeManagerConfiguration {
        modules = [
          { nixpkgs = nixpkgsConfig; }
          userModule
        ];
        pkgs = inputs.nixpkgs.outputs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs; };
      };
    in {
      lora = mkUser {
        system = "x86_64-linux";
        userModule = ./user/lora.nix;
      };
      python = mkUser {
        system = "x86_64-linux";
        userModule = ./user/python.nix;
      };
    };

    packages =
    let
      system = "x86_64-linux";
    in {
      ${system} = import ./packages {
        inherit system inputs nixpkgsConfig;
      };
    };
  };
}

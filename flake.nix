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
    nixpkgs-config = {
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

    nixosConfigurations.lora = import ./hosts/lora {
      inherit inputs nixpkgs-config;
    };
    nixosConfigurations.python = import ./hosts/python {
      inherit inputs nixpkgs-config;
    };

    homeConfigurations.robin = import ./users/robin {
      inherit inputs nixpkgs-config;
    };

    packages =
    let
      system = "x86_64-linux";
    in {
      ${system} = import ./packages {
        inherit system inputs nixpkgs-config;
      };
    };
  };
}

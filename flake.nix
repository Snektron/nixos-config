{
  description = "Snektrons's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";

    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
  let
    config = {
      allowUnfree = true;
      # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1119760100
      allowUnfreePredicate = (pkg: true);
    };
    overlays = import ./overlays;
  in rec {
    lib = import ./lib {
      inherit inputs config overlays;
    };
    nixosConfigurations.lora = import ./hosts/lora {
      inherit inputs config overlays;
    };
    homeConfigurations.robin = import ./users/robin {
      inherit inputs config overlays;
    };
  };
}

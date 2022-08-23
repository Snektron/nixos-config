{
  description = "Snektrons's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
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

    packages.x86_64-linux =
    let
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    in {
      hip = pkgs.callPackage ./packages/hip.nix {
        inherit (pkgs) rocm-device-libs rocm-thunk rocm-runtime rocminfo rocclr rocm-opencl-runtime rocm-comgr;
        inherit (pkgs.llvmPackages_rocm) clang clang-unwrapped llvm compiler-rt lld;
      };
    };
  };
}

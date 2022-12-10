{ inputs, nixpkgsConfig }:
inputs.nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";

  modules = [
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga401
    {
      nixpkgs = { inherit system; } // nixpkgsConfig;
      nix = import ../../nix-settings.nix { inherit inputs system; };
    }
    # Use the pinned inputs as channels in the final configuration.
    (import ../../utils/link-inputs.nix inputs)
    ./configuration.nix
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
  ];

  specialArgs = { inherit inputs; };
}

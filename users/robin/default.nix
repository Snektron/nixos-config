{ config, overlays, inputs }:
inputs.home-manager.lib.homeManagerConfiguration rec {
  modules = [
    {
      nixpkgs = { inherit config overlays; };
    }
    ./home.nix
  ];

  # TODO: Perhaps the arch should not be hardcoded here?
  pkgs = inputs.nixpkgs.outputs.legacyPackages.x86_64-linux;

  extraSpecialArgs = { inherit inputs; };
}

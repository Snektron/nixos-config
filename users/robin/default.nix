{ inputs, nixpkgs-config }:
let
  # TODO: Perhaps the arch should not be hardcoded here?
  system = "x86_64-linux";
in inputs.home-manager.lib.homeManagerConfiguration {
  modules = [
    {
      nixpkgs = nixpkgs-config;
    }
    ./home.nix
  ];

  pkgs = inputs.nixpkgs.outputs.legacyPackages.${system};

  extraSpecialArgs = { inherit inputs; };
}

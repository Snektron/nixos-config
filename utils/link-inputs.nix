# https://git.chir.rs/darkkirb/nixos-config/src/branch/main/utils/link-input.nix
inputs: {lib, ...}: let
  inherit (lib) filterAttrs mapAttrs';
  flakes = filterAttrs (name: value: value ? outputs) inputs;
  nixRegistry =
    builtins.mapAttrs
    (name: v: {flake = v;})
    flakes;
in {
  nix.registry = nixRegistry;
  environment.etc =
    mapAttrs'
    (name: value: {
      name = "nix/inputs/${name}";
      value = {source = value.outPath;};
    })
    inputs;
  nix.nixPath = ["/etc/nix/inputs"];
}

{
  description = "i3-compatible Wayland compositor";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        sway-unwrapped = pkgs.sway-unwrapped.overrideAttrs (
          previous: {
            src = pkgs.nix-gitignore.gitignoreSource [ ./.nixignore ] ./.;
          }
        );
        sway = pkgs.sway.override {sway-unwrapped=sway-unwrapped;};
      in
      {
        packages.default = sway;
        devShells.default = pkgs.mkShell { inputsFrom = [ sway ]; };
      }
    );
}

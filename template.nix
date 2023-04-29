{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, fenix, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system: 
    let
      # enter your project name below
      projectName = "my-tauri-project";

      pkgs = nixpkgs.legacyPackages.${system};
      toolchain = fenix.packages.${system}.minimal.toolchain;
      deps = [
        pkgs.libiconv
        toolchain
      ] ++ (with pkgs; [
        libiconv
        nodejs-16_x
      ]) ++ nixpkgs.lib.optionals pkgs.stdenv.isDarwin [(with pkgs.darwin.apple_sdk.frameworks; [
        Security
        CoreGraphics
        Cocoa
        Foundation
        WebKit
      ])];
    in
    {
      packages.default =
        (pkgs.makeRustPlatform {
          cargo = toolchain;
          rustc = toolchain;
        }).buildRustPackage {
          pname = projectName;
          version = "0.1.0";
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
        };
      devShell = pkgs.mkShell {
        buildInputs = deps;
      };
    });
}
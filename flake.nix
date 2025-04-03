{
  description = "Trash/Cringe post collection website by Floss Uzbekistan community";

  inputs = {
    # Too old to work with most libraries
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # Perfect!
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # The flake-utils library
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        # Nix script formatter
        formatter = pkgs.alejandra;

        # Development environment
        devShells.default = import ./shell.nix {inherit pkgs;};

        # Output package
        packages = {
          default = pkgs.callPackage ./default.nix {inherit pkgs;};
          standalone = pkgs.callPackage ./default-stdl.nix {inherit pkgs;};
        };
      }
    )
    // {
      # Deployment module
      nixosModules.server = import ./module.nix self;
    };
}

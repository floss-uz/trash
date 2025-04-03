{
  pkgs ? let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
    import nixpkgs {overlays = [];},
  ...
}: let
  manifest = pkgs.lib.importJSON ./package.json;

  exec = pkgs.writeShellScript "${manifest.name}-start.sh" ''
    # Change working directory to script
    cd "$(dirname "$0")/../lib"

    ${pkgs.lib.getExe pkgs.nodejs} ./server.js
  '';
in
  # pkgs.stdenv.mkDerivation {
  pkgs.buildNpmPackage {
    pname = manifest.name;
    version = manifest.version;

    src = ./.;
    npmDepsHash = "sha256-PEM9giBsN0/RzCnW+88o4n8u5U+vy27YUlu5OnYEigo=";

    prePatch = ''
      sed -i.bak "s/output: 'export',/output: 'standalone',/" next.config.mjs
      sed -i.bak "s/unoptimized: true,/unoptimized: false,/" next.config.mjs
    '';

    installPhase = ''
      # Create output directory
      mkdir -p $out

      # Copy standalone as library
      cp -R ./.next/standalone $out/lib

      # Copy static contents
      if [ -d "./.next/static" ]; then
        cp -R ./.next/static $out/lib/.next/static
      fi

      # Copy public assets
      if [ -d "./public" ]; then
        cp -R ./public $out/lib/public
      fi

      # Create executable directory
      mkdir -p $out/bin

      # Copy shell script to executables
      cp -r ${exec} $out/bin/${manifest.name}-start
    '';

    nativeBuildInputs = with pkgs; [
      # Typescript
      nodejs
      pnpm
      corepack

      # Hail the Nix
      nixd
      statix
      alejandra
    ];

    buildInputs = with pkgs; [
      openssl
      vips
    ];

    NODE_TLS_REJECT_UNAUTHORIZED = 0;

    meta = with pkgs.lib; {
      homepage = "https://trash.floss.uz";
      mainProgram = "${manifest.name}-start";
      description = manifest.description;
      license = with licenses; [cc-by-40];
      platforms = with platforms; linux ++ darwin;
      maintainers = with maintainers; [orzklv];
    };
  }

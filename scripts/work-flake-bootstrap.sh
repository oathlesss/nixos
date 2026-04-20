#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -eq 0 ]; then
  set -- "$PWD"
fi

write_envrc() {
  cat > "$1/.envrc" <<'EOF_ENVRC'
use flake path:$PWD
EOF_ENVRC
}

write_mokum_flake() {
  cat > "$1/flake.nix" <<'EOF_FLAKE'
{
  description = "Mokum development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python313
          uv
          pkg-config
          postgresql.dev
          (writeShellScriptBin "pg_config" ''
            config="${postgresql.dev}/nix-support/pg_config.expected"
            if [ "$#" -eq 0 ]; then
              cat "$config"
              exit 0
            fi
            for arg in "$@"; do
              key="$(echo "''${arg#--}" | tr '[:lower:]' '[:upper:]')"
              value="$(grep "^$key = " "$config" | sed "s/^$key = //")"
              echo "$value"
            done
          '')
        ];

        env.UV_PYTHON_DOWNLOADS = "never";
      };
    };
}
EOF_FLAKE
}

write_centric_flake() {
  cat > "$1/flake.nix" <<'EOF_FLAKE'
{
  description = "Centric development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python313
          uv
          pkg-config
          postgresql.dev
          file
          gnumake
          docker
          docker-compose
        ];

        env.UV_PYTHON_DOWNLOADS = "never";
      };
    };
}
EOF_FLAKE
}

write_rodk_flake() {
  cat > "$1/flake.nix" <<'EOF_FLAKE'
{
  description = "RODK development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python313
          uv
          pkg-config
          postgresql.dev
          gnumake
          docker
          docker-compose
        ];

        env.UV_PYTHON_DOWNLOADS = "never";
      };
    };
}
EOF_FLAKE
}

write_bigdatarepublic_flake() {
  cat > "$1/flake.nix" <<'EOF_FLAKE'
{
  description = "BigDataRepublic development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python313
          uv
          nodejs_18
        ];

        env.UV_PYTHON_DOWNLOADS = "never";
      };
    };
}
EOF_FLAKE
}

write_muxyard_flake() {
  cat > "$1/flake.nix" <<'EOF_FLAKE'
{
  description = "Muxyard development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          go
          gopls
        ];
      };
    };
}
EOF_FLAKE
}

for repo_path in "$@"; do
  repo_path="$(cd "$repo_path" && pwd)"
  repo_name="$(basename "$repo_path")"

  case "$repo_name" in
    mokum)
      write_mokum_flake "$repo_path"
      ;;
    centric)
      write_centric_flake "$repo_path"
      ;;
    rodk)
      write_rodk_flake "$repo_path"
      ;;
    bigdatarepublic)
      write_bigdatarepublic_flake "$repo_path"
      ;;
    muxyard)
      write_muxyard_flake "$repo_path"
      ;;
    *)
      echo "Unsupported repo: $repo_name" >&2
      exit 1
      ;;
  esac

  write_envrc "$repo_path"
done

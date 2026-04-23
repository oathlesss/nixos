{
  description = "Ruben's NixOS on Asahi";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      apple-silicon,
      niri,
      ...
    }:
    let
      pkgs = import nixpkgs { system = "aarch64-linux"; };
      pre-commit-check = inputs.git-hooks.lib.aarch64-linux.run {
        src = ./.;
        hooks = {
          deadnix.enable = true;
          statix.enable = true;
          nixfmt-rfc-style.enable = true;
        };
      };
    in
    {
      nixosConfigurations.asahi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          apple-silicon.nixosModules.apple-silicon-support
          niri.nixosModules.niri
          ./hosts/asahi/configuration.nix
        ];
      };

      homeConfigurations.ruben = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./hosts/asahi/home.nix ];
      };

      devShells.aarch64-linux.default = pkgs.mkShell {
        inherit (pre-commit-check) shellHook;
      };
    };
}

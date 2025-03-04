{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";

    snacks-nvim = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };
    trouble-nvim = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };
  };

  outputs = {
    nixvim,
    flake-parts,
    self,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [
        inputs.git-hooks-nix.flakeModule
        ./flake/pkgs-by-name.nix
      ];

      perSystem = {
        config,
        system,
        pkgs,
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nixvimModule = {
          inherit system; # or alternatively, set `pkgs`
          module = import ./config; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            inherit inputs system self;
          };
        };
        nvim = nixvim'.makeNixvimWithModule nixvimModule;
      in {
        imports = [
          ./pre-commit.nix
        ];
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };

        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell {
          shellHook = ''
            ${config.pre-commit.installationScript}
            echo 1>&2 "Welcome to the development shell!"
          '';
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim;
        };
      };
      flake = {
        # Export as both NixOS and home-manager modules
        nixosModules.nixvim = {...}: {
          imports = [nixvim.nixosModules.nixvim];
          programs.nixvim = import ./config;
        };

        # Add home-manager module
        homeModules.nixvim = {...}: {
          imports = [nixvim.homeManagerModules.nixvim];
          programs.nixvim = import ./config;
        };
      };
    };
}

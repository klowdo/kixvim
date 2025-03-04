{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.nixvim.flakeModules.default
  ];

  nixvim = {
    packages.enable = true;
    checks.enable = true;
  };

  flake.nixvimModules = {
    default = ../config;
  };

  perSystem = {system, ...}: let
    nixvimModule = {
      inherit system;
      module = self.nixvimModules.default;
      extraSpecialArgs = {
        inherit inputs system self;
      };
    };
  in {
    nixvimConfigurations = {
      default = nixvimModule;
      # nixvim = inputs.nixvim.lib.evalNixvim nixvimModule;
    };
  };

  flake = {
    # Export as both NixOS and home-manager modules
    nixosModules.nixvim = {...}: {
      imports = [inputs.nixvim.nixosModules.nixvim];
      programs.nixvim = import ../config;
    };

    # Add home-manager module
    homeModules.nixvim = {...}: {
      imports = [inputs.nixvim.homeManagerModules.nixvim];
      programs.nixvim = import ../config;
    };
  };
}

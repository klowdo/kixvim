# Inspo: https://github.com/elythh/nixvim
{
  inputs,
  lib,
  self,
  ...
}: {
  imports = [
    ./checks.nix
    ./devshell.nix
    # ./git-hooks.nix
    ./nixvim.nix
    ./pkgs-by-name.nix
    # ./treefmt.nix
  ];

  perSystem = {
    config,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = lib.attrValues self.overlays;
      config.allowUnfree = true;
    };

    packages.default = config.packages.nixvim;
  };
}

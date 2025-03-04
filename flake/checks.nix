{
  inputs,
  self,
  ...
}: {
  perSystem = {system, ...}: let
    nixvimLib = inputs.nixvim.lib.${system};
    # nixvimModule = {
    #   inherit system; # or alternatively, set `pkgs`
    #   module = import ../config; # import the module directly
    #   # You can use `extraSpecialArgs` to pass additional arguments to your module files
    #   extraSpecialArgs = {
    #     inherit self;
    #     # inherit (inputs) foo;
    #   };
    # };
  in {
    checks = {
      # Run `nix flake check .` to verify that your config is not broken
      default = nixvimLib.check.mkTestDerivationFromNixvimModule self.nixvimConfigurations.${system}.default;
    };
  };
}

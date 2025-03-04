{
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      name = "Klowdo's Nixvim development shell";
      meta.description = "Shell environment for modifying this Nix configuration";
      shellHook = ''
        ${config.pre-commit.installationScript}
        echo 1>&2 "Welcome to the development shell!"
      '';
    };
  };
}

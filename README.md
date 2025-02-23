# Kixvim (Klowdo's nixvim)

This flake provies my nixvim configuration.
I've mainly broken out this config to easier test new
stuff without rebuilding nixos.
alias `ndev = nix run ./path/to/kixvim/repo/`

## Installation

### flake.nix

```nix
inputs = {
    kixvim.url = "github:klowdo/kixvim";
};
```

### configuration.nix

```nix
imports = [
    nixvim.nixosModules.nixvim
];

programs.nixvim.enable = true;
```

### home-manager.nix

```nix
imports = [
    nixvim.homeManagerModules.nixvim
];

programs.nixvim.enable = true;
```

## Configuring

To start configuring, just add or modify the nix files in `./config`.
If you add a new configuration file, remember to add it to the
[`config/default.nix`](./config/default.nix) file

## Testing your new configuration

To test your configuration simply run the following command

``` nix
nix run .
```

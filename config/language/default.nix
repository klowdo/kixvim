{
  imports = [
    ./dotnet.nix
    ./templ.nix
    ./go.nix
    ./golangci-lint.nix
    ./rust.nix
    # ./vim-go.nix  # Disabled - using go.nvim instead (language/go.nix)
  ];
}

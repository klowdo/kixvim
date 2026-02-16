{
  imports = [
    ./telescope.nix
    ./debug.nix
    ./neotest.nix
    ./overseer.nix
    ./auto-session.nix
    ./persistence.nix
    ./remote-nvim.nix
    ./remote-sshfs.nix
    # ./toggleterm.nix  # Disabled - using Snacks terminal instead
    # ./dadbod.nix
  ];
}

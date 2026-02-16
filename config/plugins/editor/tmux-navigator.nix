{
  # https://nix-community.github.io/nixvim/plugins/tmux-navigator/index.html
  plugins.tmux-navigator = {
    enable = true;
    settings = {
      # Disable tmux navigation when in insert mode to prevent commands showing up
      disable_when_zoomed = 1;
      # Don't write commands when navigating
      preserve_zoom = 1;
    };
  };

  # Ensure navigation only works in normal mode, not insert mode
  keymaps = [
    {
      mode = "n";
      key = "<C-h>";
      action = "<cmd>TmuxNavigateLeft<CR>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<cmd>TmuxNavigateDown<CR>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<cmd>TmuxNavigateUp<CR>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<cmd>TmuxNavigateRight<CR>";
      options = {silent = true;};
    }
  ];
}

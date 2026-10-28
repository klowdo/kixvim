{pkgs, ...}: let
  navigate = key: direction: {
    mode = "n";
    key = "<C-${key}>";
    action.__raw = ''
      function()
        vim.cmd((vim.env.HERDR_PANE_ID and "HerdrNavigate" or "TmuxNavigate") .. "${direction}")
      end
    '';
    options = {silent = true;};
  };
in {
  # https://nix-community.github.io/nixvim/plugins/tmux-navigator/index.html
  plugins.tmux-navigator = {
    enable = true;
    settings = {
      # Disable tmux navigation when in insert mode to prevent commands showing up
      disable_when_zoomed = 1;
      # Don't write commands when navigating
      preserve_zoom = 1;
      no_mappings = 1;
    };
  };

  # https://github.com/bojackduy/nvim-herdr-navigation
  extraPlugins = [pkgs.nvim-herdr-navigation];

  # Ensure navigation only works in normal mode, not insert mode
  keymaps = [
    (navigate "h" "Left")
    (navigate "j" "Down")
    (navigate "k" "Up")
    (navigate "l" "Right")
  ];
}

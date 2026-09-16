{
  # https://nix-community.github.io/nixvim/plugins/obsidian/settings/index.html
  plugins.obsidian = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings = {
        ft = "markdown";
      };
    };

    settings = {
      completion = {
        min_chars = 2;
      };
      new_notes_location = "current_dir";
      # Disable legacy commands to avoid deprecation warning
      legacy_commands = false;
      daily_notes = {
        folder = "daily";
      };
      workspaces = [
        {
          name = "notes";
          path = "~/notes";
        }
      ];
    };
  };
}

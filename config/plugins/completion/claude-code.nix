{pkgs, ...}: {
  plugins.claude-code = {
    enable = false;
    package = pkgs.vimPlugins.claude-code-nvim;
  };
  dependencies.claude-code = {
    enable = false;
  };
}

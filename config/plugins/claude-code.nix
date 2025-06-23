{pkgs, ...}: {
  plugins.claude-code = {
    enable = true;
    package = pkgs.vimPlugins.claude-code-nvim;
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>cC";
      action = "<cmd>ClaudeCode<CR>";
      options = {
        desc = "Toggle Claude Code";
      };
    }
  ];
  dependencies.claude-code = {
    enable = true;
    package = pkgs.claude-code.overrideAttrs (oldAttrs: rec {
      version = "1.0.30";
      src = pkgs.fetchzip {
        url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
        hash = "sha256-DwzSXpDrNV8FhfqrRQ3OK/LjmiXd+VHEW91jnyds2P4=";
      };
      npmDepsHash = "sha256-Khd1S/8zNQy6It4XcfJQmmLs1IDyoCd+ZxPBHuacjkw=";
    });
  };
}

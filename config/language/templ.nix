{pkgs, ...}: {
  # templ language support for Go templating
  # https://github.com/a-h/templ

  # Add templ tree-sitter grammar for syntax highlighting
  plugins.treesitter = {
    grammarPackages = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.templ];
  };

  # Configure comment.nvim for templ files
  plugins.comment = {
    settings = {
      pre_hook.__raw = ''
        require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
      '';
    };
  };

  # Add ts-context-commentstring for proper commenting in templ files
  extraPlugins = with pkgs.vimPlugins; [
    nvim-ts-context-commentstring
  ];

  extraConfigLua = ''
    require('ts_context_commentstring').setup {
      enable_autocmd = false,
    }
  '';
}

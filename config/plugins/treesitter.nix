{pkgs, ...}: {
  # Highlight, edit, and navigate code
  # https://nix-community.github.io/nixvim/plugins/treesitter/index.html
  plugins.treesitter = {
    enable = true;

    # TODO: Don't think I need this as nixGrammars is true which should atuo install these???
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      c
      diff
      html
      bash
      json
      lua
      make
      markdown
      nix
      regex
      toml
      vim
      vimdoc
      yaml
      terraform
      just
      gitcommit
      git-rebase
      git-rebase
      gitignore
      ## go lang
      go
      goctl
      gosum
      gotmpl
      gowork
      gomod
    ];
    settings = {
      indent = {
        enable = true;
      };
    };

    # TODO: Figure out how to do this
    #highlight = {
    #  enable = true;

    # Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    #  If you are experiencing weird indenting issues, add the language to
    #  the list of additional_vim_regex_highlighting and disabled languages for indent.
    #  additional_vim_regex_highlighting = [
    #    "ruby"
    #  ];
    #};

    #enable = true;
    # TODO: Figure out how to do this
    #disable = [
    #  "ruby"
    #];
    #};

    # There are additional nvim-treesitter modules that you can use to interact
    # with nvim-treesitter. You should go explore a few and see what interests you:
    #
    #    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    #    - Show your current context: https://nix-community.github.io/nixvim/plugins/treesitter-context/index.html
    #    - Treesitter + textobjects: https://nix-community.github.io/nixvim/plugins/treesitter-textobjects/index.html
  };
}

{
  pkgs,
  config,
  lib,
  ...
}: {
  # Highlight, edit, and navigate code
  # https://nix-community.github.io/nixvim/plugins/treesitter/index.html
  plugins = {
    treesitter = {
      enable = true;
      folding = false; #COOL but.. need to know how to use

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
        hcl
      ];
      settings = {
        nixvimInjections = true;

        highlight = {
          additional_vim_regex_highlighting = true;
          enable = true;
          disable =
            # Lua
            ''
              function(lang, bufnr)
                return vim.api.nvim_buf_line_count(bufnr) > 10000
              end
            '';
        };

        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "gnn";
            node_incremental = "grn";
            scope_incremental = "grc";
            node_decremental = "grm";
          };
        };

        indent = {
          enable = true;
        };
      };
    };

    treesitter-context = {
      inherit (config.plugins.treesitter) enable;
      settings = {
        max_lines = 4;
        min_window_height = 40;
        multiwindow = true;
        separator = "-";
      };
    };

    treesitter-refactor = {
      inherit (config.plugins.treesitter) enable;

      highlightDefinitions = {
        enable = true;
        clearOnCursorMove = true;
      };
      smartRename = {
        enable = true;
      };
      navigation = {
        enable = true;
      };
    };
  };

  # There are additional nvim-treesitter modules that you can use to interact
  # with nvim-treesitter. You should go explore a few and see what interests you:
  #
  #    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  #    - Show your current context: https://nix-community.github.io/nixvim/plugins/treesitter-context/index.html
  #    - Treesitter + textobjects: https://nix-community.github.io/nixvim/plugins/treesitter-textobjects/index.html

  keymaps = lib.mkIf config.plugins.treesitter-context.enable [
    {
      mode = "n";
      key = "<leader>ut";
      action = "<cmd>TSContextToggle<cr>";
      options = {
        desc = "Treesitter Context toggle";
      };
    }
  ];
}

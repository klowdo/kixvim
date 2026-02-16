{
  config,
  lib,
  ...
}: {
  # Highlight, edit, and navigate code
  # https://nix-community.github.io/nixvim/plugins/treesitter/index.html
  plugins = {
    treesitter = {
      enable = true;
      folding.enable = false;

      # nixGrammars = true (default) includes all 325+ grammars automatically.
      # To use a custom subset, use the new style with package.grammarPlugins:
      # grammarPackages = with config.plugins.treesitter.package.grammarPlugins; [
      #   go gotmpl gomod gosum gowork rust c cpp nix lua bash json yaml
      #   terraform hcl markdown vim vimdoc html sql comment diff
      #   gitcommit git_rebase gitignore toml regex make just helm templ
      # ];

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

    # NOTE: treesitter-refactor is disabled because it depends on the legacy
    # nvim-treesitter which conflicts with NixVim's new treesitter.
    # The features (highlight_definitions, smart_rename, navigation) are
    # available via LSP instead.
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

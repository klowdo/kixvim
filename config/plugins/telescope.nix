{
  imports = [
    ./telescope/manix.nix
  ];
  # Fuzzy Finder (files, lsp, etc)
  # https://nix-community.github.io/nixvim/plugins/telescope/index.html
  plugins.telescope = {
    # Telescope is a fuzzy finder that comes with a lot of different things that
    # it can fuzzy find! It's more than just a "file finder", it can search
    # many different aspects of Neovim, your workspace, LSP, and more!
    #
    # The easiest way to use Telescope, is to start by doing something like:
    #  :Telescope help_tags
    #
    # After running this command, a window will open up and you're able to
    # type in the prompt window. You'll see a list of `help_tags` options and
    # a corresponding preview of the help.
    #
    # Two important keymaps to use while in Telescope are:
    #  - Insert mode: <c-/>
    #  - Normal mode: ?
    #
    # This opens a window that shows you all of the keymaps for the current
    # Telescope picker. This is really useful to discover what Telescope can
    # do as well as how to actually do it!
    #
    # [[ Configure Telescope ]]
    # See `:help telescope` and `:help telescope.setup()`
    enable = true;

    # Enable Telescope extensions
    extensions = {
      fzf-native.enable = true;
      ui-select.enable = true;
    };

    #  # You can put your default mappings / updates / etc. in here
    #  #  See `:help telescope.builtin`
    keymaps = {
      # "<leader>sh" = {
      #   mode = "n";
      #   action = "help_tags";
      #   options = {
      #     desc = "[S]earch [H]elp";
      #   };
      # };
      "<leader>sk" = {
        mode = "n";
        action = "keymaps";
        options = {
          desc = "[S]earch [K]eymaps";
        };
      };
      "<leader>sf" = {
        mode = "n";
        action = "find_files";
        options = {
          desc = "[S]earch [F]iles";
        };
      };
      "<leader>ss" = {
        mode = "n";
        action = "builtin";
        options = {
          desc = "[S]earch [S]elect Telescope";
        };
      };
      "<leader>sw" = {
        mode = "n";
        action = "grep_string";
        options = {
          desc = "[S]earch current [W]ord";
        };
      };
      "<leader>sg" = {
        mode = "n";
        action = "live_grep";
        options = {
          desc = "[S]earch by [G]rep";
        };
      };
      "<leader>sd" = {
        mode = "n";
        action = "diagnostics";
        options = {
          desc = "[S]earch [D]iagnostics";
        };
      };
      "<leader>sr" = {
        mode = "n";
        action = "resume";
        options = {
          desc = "[S]earch [R]esume";
        };
      };
      "<leader>s" = {
        mode = "n";
        action = "oldfiles";
        options = {
          desc = "[S]earch Recent Files ('.' for repeat)";
        };
      };
      "<leader><leader>" = {
        mode = "n";
        action = "buffers";
        options = {
          desc = "[ ] Find existing buffers";
        };
      };
      "<leader>fs" = {
        action = "lsp_document_symbols";
        options.desc = "Search symbols";
      };
    };
    settings = {
      extensions.__raw = "{ ['ui-select'] = { require('telescope.themes').get_dropdown() } }";
      defaults = {
        # Follow symbolic links
        follow = true;
        # Respect gitignore
        vimgrep_arguments = [
          "rg"
          "--color=never"
          "--no-heading"
          "--with-filename"
          "--line-number"
          "--column"
          "--smart-case"
          "--hidden"
          "--glob=!.git/"
        ];
      };
      pickers = {
        find_files = {
          hidden = true;
          # Respect gitignore but show hidden files
          find_command = ["fd" "--type" "f" "--hidden" "--follow" "--exclude" ".git"];
        };
        live_grep = {
          additional_args = ["--hidden" "--glob=!.git/"];
        };
        grep_string = {
          additional_args = ["--hidden" "--glob=!.git/"];
        };
        git_files = {
          # Already respects git root by nature
          show_untracked = true;
        };
      };
    };
  };

  # Configure telescope to use git root
  extraConfigLua = ''
    -- Function to get git root or fallback to current directory
    local function get_git_root()
      local git_root = vim.fs.root(0, {".git", "_darcs", ".hg", ".bzr", ".svn"})
      return git_root or vim.fn.getcwd()
    end

    -- Override default telescope configuration to use git root as default cwd
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    telescope.setup({
      defaults = {
        -- Set default search path to git root
        cwd = get_git_root(),
        path_display = { "truncate" },
        file_ignore_patterns = {
          "%.git/",
          "node_modules/",
          "%.pytest_cache/",
          "__pycache__/",
          "%.cache/",
        },
      },
      pickers = {
        find_files = {
          cwd = get_git_root(),
          find_command = { "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git" },
        },
        live_grep = {
          cwd = get_git_root(),
        },
        grep_string = {
          cwd = get_git_root(),
        },
      },
    })
  '';

  # # https://nix-community.github.io/nixvim/keymaps/index.html
  # keymaps = [
  #   # Slightly advanced example of overriding default behavior and theme
  #   {
  #     mode = "n";
  #     key = "<leader>/";
  #     # You can pass additional configuration to Telescope to change the theme, layout, etc.
  #     action.__raw = ''
  #       function()
  #         require('telescope.builtin').current_buffer_fuzzy_find(
  #           require('telescope.themes').get_dropdown {
  #             winblend = 10,
  #             previewer = false
  #           }
  #         )
  #       end
  #     '';
  #     options = {
  #       desc = "[/] Fuzzily search in current buffer";
  #     };
  #   }
  #   {
  #     mode = "n";
  #     key = "<leader>s/";
  #     # It's also possible to pass additional configuration options.
  #     #  See `:help telescope.builtin.live_grep()` for information about particular keys
  #     action.__raw = ''
  #       function()
  #         require('telescope.builtin').live_grep {
  #           grep_open_files = true,
  #           prompt_title = 'Live Grep in Open Files'
  #         }
  #       end
  #     '';
  #     options = {
  #       desc = "[S]earch [/] in Open Files";
  #     };
  #   }
  #   # Shortcut for searching your Neovim configuration files
  #   {
  #     mode = "n";
  #     key = "<leader>sn";
  #     action.__raw = ''
  #       function()
  #         require('telescope.builtin').find_files {
  #           cwd = vim.fn.stdpath 'config'
  #         }
  #       end
  #     '';
  #     options = {
  #       desc = "[S]earch [N]eovim files";
  #     };
  #   }
  # ];
}

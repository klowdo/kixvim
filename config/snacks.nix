{
  plugins.dashboard = {
    enable = false;
    settings = {
      theme = "hyper";
      config.header = [
        "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
        "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
        "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
        "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
        "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
        "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
      ];
      shortcut = [
        {
          action = {
            __raw = "function(path) vim.cmd('Telescope find_files') end";
          };
          desc = "Files";
          group = "Label";
          icon = " ";
          icon_hl = "@variable";
          key = "f";
        }
        {
          action = "Telescope app";
          desc = " Apps";
          group = "DiagnosticHint";
          key = "a";
        }
        {
          action = "Telescope dotfiles";
          desc = " dotfiles";
          group = "Number";
          key = "d";
        }
      ];
      week_header = {
        enable = true;
      };

      #     project = {
      #   enable = false;
      # };
    };
  };
  plugins.noice.enable = true;
  plugins.snacks = {
    enable = true;
    settings = {
      bigfile = {enabled = true;};
      # dashboard = {enabled = true;};
      indent = {enabled = true;};
      input = {enabled = true;};
      notifier = {enabled = true;};
      quickfile = {enabled = true;};
      scroll = {enabled = true;};
      statuscolumn = {enabled = true;};
      words = {enabled = true;};
      terminal = {
        enabled = true;
      };

      lazygit = {
        enabled = true;
      };
    };
  };

  keymaps = [
    {
      mode = "";
      # mode = "n";
      key = "<leader>lg";
      action = "<cmd>LazyGit<CR>";
    }
    {
      key = "<leader>n";
      action = "<CMD>lua Snacks.picker.notifications() <CR>";
      options = {
        desc = "Notification History";
      };
    }
    {
      key = "<leader>e";
      action = "<CMD>lua Snacks.explorer() <CR>";
      options = {desc = "File Explorer";};
    }
    # # -- find
    {
      key = "<leader>fb";
      action = "<CMD>lua Snacks.picker.buffers() <CR>";
      options = {desc = "Buffers";};
    }
    {
      key = "<leader>fc";
      action = "<CMD>lua Snacks.picker.files({ cwd = vim.fn.stdpath(\"config\") }) <CR>";
      options = {desc = "Find Config File";};
    }
    {
      key = "<leader>ff";
      action = "<CMD>lua Snacks.picker.files() <CR>";
      options = {desc = "Find Files";};
    }
    {
      key = "<leader>fg";
      action = "<CMD>lua Snacks.picker.git_files() <CR>";
      options = {desc = "Find Git Files";};
    }
    {
      key = "<leader>fp";
      action = "<CMD>lua Snacks.picker.projects() <CR>";
      options = {desc = "Projects";};
    }
    {
      key = "<leader>fr";
      action = "<CMD>lua Snacks.picker.recent() <CR>";
      options = {desc = "Recent";};
    }
    # #  -- git
    {
      key = "<leader>gb";
      action = "<CMD>lua Snacks.picker.git_branches() <CR>";
      options = {desc = "Git Branches";};
    }
    {
      key = "<leader>gl";
      action = "<CMD>lua Snacks.picker.git_log() <CR>";
      options = {desc = "Git Log";};
    }
    {
      key = "<leader>gL";
      action = "<CMD>lua Snacks.picker.git_log_line() <CR>";
      options = {desc = "Git Log Line";};
    }
    {
      key = "<leader>gs";
      action = "<CMD>lua Snacks.picker.git_status() <CR>";
      options = {desc = "Git Status";};
    }
    {
      key = "<leader>gS";
      action = "<CMD>lua Snacks.picker.git_stash() <CR>";
      options = {desc = "Git Stash";};
    }
    {
      key = "<leader>gd";
      action = "<CMD>lua Snacks.picker.git_diff() <CR>";
      options = {desc = "Git Diff (Hunks)";};
    }
    {
      key = "<leader>gf";
      action = "<CMD>lua Snacks.picker.git_log_file() <CR>";
      options = {desc = "Git Log File";};
    }
    # #  -- Grep
    {
      key = "<leader>sb";
      action = "<CMD>lua Snacks.picker.lines() <CR>";
      options = {desc = "Buffer Lines";};
    }
    {
      key = "<leader>sB";
      action = "<CMD>lua Snacks.picker.grep_buffers() <CR>";
      options = {desc = "Grep Open Buffers";};
    }
    {
      key = "<leader>sg";
      action = "<CMD>lua Snacks.picker.grep() <CR>";
      options = {desc = "Grep";};
    }
    {
      key = "<leader>sw";
      action = "<CMD>lua Snacks.picker.grep_word() <CR>";
      options = {desc = "Visual selection or word";};
      mode = ["n" "x"];
    }
    # # -- search
    {
      key = "<leader>s";
      action = "<CMD>lua Snacks.picker.registers() <CR>";
      options = {desc = "Registers";};
    }
    {
      key = "<leader>s/";
      action = "<CMD>lua Snacks.picker.search_history() <CR>";
      options = {desc = "Search History";};
    }
    {
      key = "<leader>sa";
      action = "<CMD>lua Snacks.picker.autocmds() <CR>";
      options = {desc = "Autocmds";};
    }
    {
      key = "<leader>sb";
      action = "<CMD>lua Snacks.picker.lines() <CR>";
      options = {desc = "Buffer Lines";};
    }
    {
      key = "<leader>sc";
      action = "<CMD>lua Snacks.picker.command_history() <CR>";
      options = {desc = "Command History";};
    }
    {
      key = "<leader>sC";
      action = "<CMD>lua Snacks.picker.commands() <CR>";
      options = {desc = "Commands";};
    }
    {
      key = "<leader>sd";
      action = "<CMD>lua Snacks.picker.diagnostics() <CR>";
      options = {desc = "Diagnostics";};
    }
    {
      key = "<leader>sD";
      action = "<CMD>lua Snacks.picker.diagnostics_buffer() <CR>";
      options = {desc = "Buffer Diagnostics";};
    }
    {
      key = "<leader>sh";
      action = "<CMD>lua Snacks.picker.help() <CR>";
      options = {desc = "Help Pages";};
    }
    {
      key = "<leader>sH";
      action = "<CMD>lua Snacks.picker.highlights() <CR>";
      options = {desc = "Highlights";};
    }
    {
      key = "<leader>si";
      action = "<CMD>lua Snacks.picker.icons() <CR>";
      options = {desc = "Icons";};
    }
    {
      key = "<leader>sj";
      action = "<CMD>lua Snacks.picker.jumps() <CR>";
      options = {desc = "Jumps";};
    }
    {
      key = "<leader>sk";
      action = "<CMD>lua Snacks.picker.keymaps() <CR>";
      options = {desc = "Keymaps";};
    }
    {
      key = "<leader>sl";
      action = "<CMD>lua Snacks.picker.loclist() <CR>";
      options = {desc = "Location List";};
    }
    {
      key = "<leader>sm";
      action = "<CMD>lua Snacks.picker.marks() <CR>";
      options = {desc = "Marks";};
    }
    {
      key = "<leader>sM";
      action = "<CMD>lua Snacks.picker.man() <CR>";
      options = {desc = "Man Pages";};
    }
    {
      key = "<leader>sp";
      action = "<CMD>lua Snacks.picker.lazy() <CR>";
      options = {desc = "Search for Plugin Spec";};
    }
    {
      key = "<leader>sq";
      action = "<CMD>lua Snacks.picker.qflist() <CR>";
      options = {desc = "Quickfix List";};
    }
    {
      key = "<leader>sR";
      action = "<CMD>lua Snacks.picker.resume() <CR>";
      options = {desc = "Resume";};
    }
    {
      key = "<leader>su";
      action = "<CMD>lua Snacks.picker.undo() <CR>";
      options = {desc = "Undo History";};
    }
    {
      key = "<leader>uC";
      action = "<CMD>lua Snacks.picker.colorschemes() <CR>";
      options = {desc = "Colorschemes";};
    }
    #   -- LSP
    {
      key = "gd";
      action = "<CMD>lua Snacks.picker.lsp_definitions() <CR>";
      options = {desc = "Goto Definition";};
    }
    {
      key = "gD";
      action = "<CMD>lua Snacks.picker.lsp_declarations() <CR>";
      options = {desc = "Goto Declaration";};
    }
    {
      key = "gr";
      action = "<CMD>lua Snacks.picker.lsp_references() <CR>";
      options = {
        nowait = true;
        desc = "References";
      };
    }
    {
      key = "gI";
      action = "<CMD>lua Snacks.picker.lsp_implementations() <CR>";
      options = {desc = "Goto Implementation";};
    }
    {
      key = "gy";
      action = "<CMD>lua Snacks.picker.lsp_type_definitions() <CR>";
      options = {desc = "Goto T[y]pe Definition";};
    }
    {
      key = "<leader>ss";
      action = "<CMD>lua Snacks.picker.lsp_symbols() <CR>";
      options = {desc = "LSP Symbols";};
    }
    {
      key = "<leader>sS";
      action = "<CMD>lua Snacks.picker.lsp_workspace_symbols() <CR>";
      options = {desc = "LSP Workspace Symbols";};
    }
    # #  -- Other
    {
      key = "<leader>z";
      action = "<CMD>lua Snacks.zen() <CR>";
      options = {desc = "Toggle Zen Mode";};
    }
    {
      key = "<leader>Z";
      action = "<CMD>lua Snacks.zen.zoom() <CR>";
      options = {desc = "Toggle Zoom";};
    }
    {
      key = "<leader>.";
      action = "<CMD>lua Snacks.scratch() <CR>";
      options = {desc = "Toggle Scratch Buffer";};
    }
    {
      key = "<leader>S";
      action = "<CMD>lua Snacks.scratch.select() <CR>";
      options = {desc = "Select Scratch Buffer";};
    }
    {
      key = "<leader>n";
      action = "<CMD>lua Snacks.notifier.show_history() <CR>";
      options = {desc = "Notification History";};
    }
    {
      key = "<leader>bd";
      action = "<CMD>lua Snacks.bufdelete() <CR>";
      options = {desc = "Delete Buffer";};
    }
    {
      key = "<leader>cR";
      action = "<CMD>lua Snacks.rename.rename_file() <CR>";
      options = {desc = "Rename File";};
    }
    {
      key = "<leader>gB";
      action = "<CMD>lua Snacks.gitbrowse() <CR>";
      options = {desc = "Git Browse";};
      mode = ["n" "v"];
    }
    {
      key = "<leader>gg";
      action = "<CMD>lua Snacks.lazygit() <CR>";
      options = {desc = "Lazygit";};
    }
    {
      key = "<leader>un";
      action = "<CMD>lua Snacks.notifier.hide() <CR>";
      options = {desc = "Dismiss All Notifications";};
    }
    {
      key = "<c-/>";
      action = "<CMD>lua Snacks.terminal() <CR>";
      options = {desc = "Toggle Terminal";};
    }
    {
      key = "<c-_>";
      action = "<CMD>lua Snacks.terminal() <CR>";
      options = {desc = "which_key_ignore";};
    }
    {
      key = "]]";
      action = "<cmd>lua Snacks.words.jump(vim.v.count1) <CR>";
      options = {desc = "Next Reference";};
      mode = ["n" "t"];
    }
    {
      key = "[[";
      action = "<cmd>lua Snacks.words.jump(-vim.v.count1) <CR>";
      options = {desc = "Prev Reference";};
      mode = ["n" "t"];
    }
  ];
}

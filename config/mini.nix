{
  plugins.mini = {
    enable = true;

    modules = {
      # Better Around/Inside textobjects
      #
      # Examples:
      #  - va)  - [V]isually select [A]round [)]paren
      #  - yinq - [Y]ank [I]nside [N]ext [']quote
      #  - ci'  - [C]hange [I]nside [']quote
      ai = {
        n_lines = 500;
      };

      # Add/delete/replace surroundings (brackets, quotes, etc.)
      #
      # Examples:
      #  - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      #  - sd'   - [S]urround [D]elete [']quotes
      #  - sr)'  - [S]urround [R]eplace [)] [']
      surround = {
      };
      files = {
      };
      icons = {};

      # Simple and easy statusline.
      #  You could remove this setup call if you don't like it,
      #  and try some other statusline plugin
      statusline = {
        use_icons.__raw = "vim.g.have_nerd_font";
      };

      # ... and there is more!
      # Check out: https://github.com/echasnovski/mini.nvim
    };
  };

  keymaps = [
    {
      key = "<leader>e";
      action = ":lua OpenMiniFileCWD()<cr>";
      options = {
        desc = "[E]xpore (Mini.files)";
      };
    }
  ];

  # You can configure sections in the statusline by overriding their
  # default behavior. For example, here we set the section for
  # cursor location to LINE:COLUMN
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraconfiglu#extraconfiglua
  # https://www.reddit.com/r/neovim/comments/1djkwif/show_recording_macros_message_in_ministatusline/
  extraConfigLua = ''
     function OpenMiniFileCWD()
      local MiniFiles = require("mini.files")
      local _ = MiniFiles.close()
        or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
      vim.defer_fn(function()
        MiniFiles.reveal_cwd()
      end, 30)
     end

    require("mini.statusline").setup({
      use_icons = vim.g.have_nerd_font,
      content = {
        active = function()
          local check_macro_recording = function()
            if vim.fn.reg_recording() ~= "" then
              return "Recording @" .. vim.fn.reg_recording()
            else
              return ""
            end
          end

          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local diff = MiniStatusline.section_diff({ trunc_width = 75 })
          local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          -- local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local location = MiniStatusline.section_location({ trunc_width = 200 })
          local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
          local macro = check_macro_recording()

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
            "%<", -- Mark general truncate point
            { hl = "MiniStatuslineFilename", strings = { filename } },
            "%=", -- End left alignment
            { hl = "MiniStatuslineFilename", strings = { macro } },
            { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
            { hl = mode_hl, strings = { search, location } },
          })
        end,
      },
    })
  '';
}

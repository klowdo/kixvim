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
  extraConfigLua = ''
     function OpenMiniFileCWD()
      local MiniFiles = require("mini.files")
      local _ = MiniFiles.close()
        or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
      vim.defer_fn(function()
        MiniFiles.reveal_cwd()
      end, 30)
     end

    require('mini.statusline').section_location = function()
      return '%2l:%-2v'
    end
  '';
}

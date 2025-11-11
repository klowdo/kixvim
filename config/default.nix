{pkgs, ...}: {
  # Import all your configuration modules here
  imports = [
    # ./bufferline.nix
    # ./vim-tmux.nix  # Disabled - using plugins/custom/plugins/tmux-navigator.nix instead
    ./snacks.nix
    ./keys.nix
    ./auto.nix
    ./lazy-loader.nix
    ./toggle-darkmode.nix
    # Plugins
    ./plugins/gitsigns.nix
    ./plugins/which-key.nix
    ./plugins/telescope.nix
    ./plugins/conform.nix
    ./plugins/lsp.nix
    ./plugins/copilot.nix
    ./plugins/nvim-cmp.nix
    ./plugins/mini.nix
    ./plugins/treesitter.nix
    ./plugins/auto-session.nix
    ./plugins/flash.nix
    ./plugins/neotest.nix
    ./plugins/otter.nix
    ./plugins/remote-nvim.nix
    ./plugins/remote-sshfs.nix
    ./plugins/spectre.nix
    ./plugins/golangci-lint.nix
    ./plugins/overseer.nix
    ./plugins/vim-go.nix
    ./plugins/claude-code.nix
    # ./plugins/diagram.nix  # Temporarily disabled due to terminal size error

    # NOTE: Add/Configure additional plugins for Kickstart.nixvim
    #
    #  Here are some example plugins that I've included in the Kickstart repository.
    #  Uncomment any of the lines below to enable them (you will need to restart nvim).
    #
    ./plugins/kickstart/plugins/debug.nix
    ./plugins/kickstart/plugins/indent-blankline.nix
    ./plugins/kickstart/plugins/lint.nix
    ./plugins/kickstart/plugins/autopairs.nix
    ./plugins/kickstart/plugins/neo-tree.nix
    ./language
    #
    # NOTE: Configure your own plugins `see https://nix-community.github.io/nixvim/`
    # Add your plugins to ./plugins/custom/plugins and import them below
    # NOTE: Not needed
    # ./plugins/custom/plugins/lazygit.nix
    # ./plugins/custom/plugins/toggleterm.nix
    # ./plugins/custom/plugins/oil.nix
    ./plugins/custom/plugins/tmux-navigator.nix
    ./plugins/custom/plugins/git-root.nix
    # ./plugins/custom/plugins/snacks.nix
    # NOTE: Not needed stops here
    ./plugins/custom/plugins/harpoon.nix
    # ./plugins/custom/plugins/dadbod.nix
    ./plugins/custom/plugins/neorg.nix
    ./plugins/custom/plugins/persistence.nix
    ./plugins/custom/plugins/obsidian.nix
    ./plugins/custom/plugins/default.nix

    #NOTE: a bit annoying.. maybe a kebinging to toggle
    # ./plugins/custom/plugins/markview.nix
    # ./plugins/custom/plugins
  ];
  enableMan = true;
  colorschemes = {
    # https://nix-community.github.io/nixvim/colorschemes/catppuccin/index.html
    catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };
  };

  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#globals
  globals = {
    # Set <space> as the leader key
    # See `:help mapleader`
    mapleader = " ";
    maplocalleader = " ";

    # Set to true if you have a Nerd Font installed and selected in the terminal
    have_nerd_font = false;
  };

  opts = {
    # Show line numbers
    number = true;
    # You can also add relative line numbers, to help with jumping.
    #  Experiment for yourself to see if you like it!
    relativenumber = true;

    # Enable mouse mode, can be useful for resizing splits for example!
    mouse = "a";

    # Don't show the mode, since it's already in the statusline
    showmode = true;

    # Sync clipboard between OS and Neovim
    #  Remove this option if you want your OS clipboard to remain independent.
    #  See `:help 'clipboard'`
    clipboard = "unnamedplus";

    # Enable break indent
    breakindent = true;

    # Save undo history
    undofile = true;

    # Case-insensitive searching UNLESS \C or one or more capital letters in search term
    ignorecase = true;
    smartcase = true;

    # Keep signcolumn on by default
    signcolumn = "yes";

    # Decrease update time
    updatetime = 250;

    # Decrease mapped sequence wait time
    # Displays which-key popup sooner
    timeoutlen = 300;

    # Configure how new splits should be opened
    splitright = true;
    splitbelow = true;

    # Sets how neovim will display certain whitespace characters in the editor
    #  See `:help 'list'`
    #  See `:help 'listchars'`
    list = true;
    # NOTE: .__raw here means that this field is raw lua code
    listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

    # Preview subsitutions live, as you type!
    inccommand = "split";

    # Show which line your cursor is on
    cursorline = true;

    # Minimal number of screen lines to keep above and below the cursor
    scrolloff = 10;

    # Set highlight on search, but clear on pressing <Esc> in normal mode
    hlsearch = true;
  };

  plugins = {
    # Adds icons for plugins to utilize in ui
    web-devicons.enable = true;

    # Detect tabstop and shiftwidth automatically
    # https://nix-community.github.io/nixvim/plugins/sleuth/index.html
    sleuth = {
      enable = true;
    };

    # "gc" to comment visual regions/lines
    # https://nix-community.github.io/nixvim/plugins/comment/index.html
    comment = {
      enable = true;
    };

    # Highlight todo, notes, etc in comments
    # https://nix-community.github.io/nixvim/plugins/todo-comments/index.html
    todo-comments = {
      settings = {
        enable = true;
        signs = true;
      };
    };
  };

  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraplugins
  extraPlugins = with pkgs.vimPlugins; [
    # Useful for getting pretty icons, but requires a Nerd Font.
    nvim-web-devicons # TODO: Figure out how to configure using this with telescope
  ];

  # TODO: Figure out where to move this
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapre
  extraConfigLuaPre = ''
    if vim.g.have_nerd_font then
      require('nvim-web-devicons').setup {}
    end
  '';

  # The line beneath this is called `modeline`. See `:help modeline`
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapost
  extraConfigLuaPost = ''
    -- Suppress Copilot limit notifications
    vim.notify = (function(orig_notify)
      return function(msg, level, opts)
        if type(msg) == "string" and msg:match("Copilot") and msg:match("limit") then
          return
        end
        return orig_notify(msg, level, opts)
      end
    end)(vim.notify)

    -- vim: ts=2 sts=2 sw=2 et
  '';

  diagnostic = {
    # NOTE: Opt-in with 0.11
    settings = {
      virtual_text = {
        severity.min = "warn";
        source = "if_many";
      };
      virtual_lines = {
        current_line = true;
      };
    };
  };
}

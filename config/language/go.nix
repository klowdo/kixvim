{pkgs, ...}: {
  # go.nvim - Modern Go development plugin
  # https://github.com/ray-x/go.nvim
  #
  # Features:
  # - Semantic highlighting with treesitter
  # - LSP integration (gopls)
  # - Test generation and running
  # - Code refactoring and formatting
  # - Debug support with DAP
  # - Inlay hints and diagnostics

  # Add required plugins
  extraPlugins = [
    pkgs.go-nvim
    pkgs.guihua-lua
  ];

  # go.nvim setup and configuration
  extraConfigLua = ''
    -- Setup go.nvim
    require('go').setup({
      -- Disable format on save (use conform.nvim instead)
      goimports = 'gopls',
      gofmt = 'gofumpt',
      tag_transform = false,
      tag_options = 'json=omitempty',

      -- Test configuration
      test_runner = 'go', -- or 'richgo', 'dlv'
      run_in_floaterm = false,

      -- LSP configuration
      -- lsp_cfg = false means we manage gopls through lspconfig (in lsp.nix)
      -- go.nvim provides additional Go-specific tooling on top of that
      lsp_cfg = false, -- Use existing LSP configuration from lsp.nix
      lsp_gofumpt = true,
      lsp_on_attach = nil, -- Use default from lsp.nix
      lsp_keymaps = false, -- Use custom keymaps below

      -- Codelens and hints: go.nvim will use gopls codelens/hints from lsp.nix
      -- These settings control go.nvim's behavior, not gopls itself
      lsp_codelens = true,
      lsp_inlay_hints = {
        enable = true,
        only_current_line = false,
        show_variable_name = true,
        parameter_hints_prefix = "󰊕 ",
        show_parameter_hints = true,
        other_hints_prefix = "=> ",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
      },

      -- Diagnostics: these override lspconfig's diagnostic settings for Go files
      lsp_diag_hdlr = true,
      lsp_diag_underline = true,
      lsp_diag_virtual_text = { space = 0, prefix = '■' },
      lsp_diag_signs = true,
      lsp_diag_update_in_insert = false,

      -- Formatting: disabled here because we use conform.nvim
      lsp_document_formatting = false,
      gopls_cmd = nil, -- Use gopls from PATH

      -- UI configuration
      dap_debug = true,
      dap_debug_gui = true,
      dap_debug_vt = true,
      textobjects = true,

      -- Icons
      icons = {
        breakpoint = '🧘',
        currentpos = '🏃',
      },

      -- Misc
      verbose = false,
      log_path = vim.fn.expand("$HOME") .. "/.cache/nvim/gonvim.log",
      lsp_semantic_highlights = true,
    })

    -- Auto-format on save for Go files
    local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        require('go.format').goimports()
      end,
      group = format_sync_grp,
    })

    -- Command to install/update Go binaries
    vim.api.nvim_create_user_command('GoInstallBinaries', function()
      require('go.install').install_all()
    end, {
      desc = 'Install/update all Go binaries required by go.nvim'
    })
  '';

  # Keymaps for go.nvim
  keymaps = [
    # Test commands
    {
      mode = "n";
      key = "<leader>gt";
      action = "<cmd>lua require('go.gotest').test()<CR>";
      options = {
        desc = "Go: Run test";
      };
    }
    {
      mode = "n";
      key = "<leader>gT";
      action = "<cmd>lua require('go.gotest').test_file()<CR>";
      options = {
        desc = "Go: Run test file";
      };
    }
    {
      mode = "n";
      key = "<leader>ga";
      action = "<cmd>lua require('go.gotest').test_package()<CR>";
      options = {
        desc = "Go: Run test package";
      };
    }

    # Code generation
    {
      mode = "n";
      key = "<leader>gie";
      action = "<cmd>GoIfErr<CR>";
      options = {
        desc = "Go: Add if err";
      };
    }
    {
      mode = "n";
      key = "<leader>gfs";
      action = "<cmd>GoFillStruct<CR>";
      options = {
        desc = "Go: Fill struct";
      };
    }
    {
      mode = "n";
      key = "<leader>gfp";
      action = "<cmd>GoFillSwitch<CR>";
      options = {
        desc = "Go: Fill switch";
      };
    }

    # Code navigation
    {
      mode = "n";
      key = "<leader>gj";
      action = "<cmd>GoJson2Struct<CR>";
      options = {
        desc = "Go: JSON to struct";
      };
    }

    # Tags
    {
      mode = "n";
      key = "<leader>gat";
      action = "<cmd>GoAddTag<CR>";
      options = {
        desc = "Go: Add tags";
      };
    }
    {
      mode = "n";
      key = "<leader>gdt";
      action = "<cmd>GoRmTag<CR>";
      options = {
        desc = "Go: Delete/remove tags";
      };
    }

    # Comments and docs
    {
      mode = "n";
      key = "<leader>gc";
      action = "<cmd>GoCmt<CR>";
      options = {
        desc = "Go: Generate comment";
      };
    }

    # Build and run
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>GoBuild<CR>";
      options = {
        desc = "Go: Build";
      };
    }
    {
      mode = "n";
      key = "<leader>gR";
      action = "<cmd>GoRun<CR>";
      options = {
        desc = "Go: Run";
      };
    }

    # Debug
    {
      mode = "n";
      key = "<leader>gd";
      action = "<cmd>GoDebug<CR>";
      options = {
        desc = "Go: Debug";
      };
    }
    {
      mode = "n";
      key = "<leader>gdt";
      action = "<cmd>GoDebug -t<CR>";
      options = {
        desc = "Go: Debug test (current function)";
      };
    }
    {
      mode = "n";
      key = "<leader>gdT";
      action.__raw = ''
        function()
          require('dap-go').debug_test()
        end
      '';
      options = {
        desc = "Go: Debug nearest test (dap-go)";
      };
    }
    {
      mode = "n";
      key = "<leader>gds";
      action = "<cmd>GoDebug -s<CR>";
      options = {
        desc = "Go: Debug (stop)";
      };
    }
    {
      mode = "n";
      key = "<leader>gdb";
      action = "<cmd>GoBreakToggle<CR>";
      options = {
        desc = "Go: Toggle breakpoint";
      };
    }
  ];
}

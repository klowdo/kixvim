{pkgs, ...}: {
  extraPlugins = [
    pkgs.vimPlugins.vim-go
  ];

  # vim-go configuration for remote debugging
  globals = {
    # Set default remote debug address to port 40000
    go_debug_address = "127.0.0.1:40000";

    # Enable additional vim-go features
    go_fmt_command = "goimports";
    go_auto_type_info = 1;
    go_highlight_types = 1;
    go_highlight_fields = 1;
    go_highlight_functions = 1;
    go_highlight_function_calls = 1;
    go_highlight_operators = 1;
    go_highlight_extra_types = 1;
    go_highlight_build_constraints = 1;
    go_highlight_generate_tags = 1;
  };

  # Custom commands for vim-go remote debugging
  extraConfigLua = ''
    -- Command to connect to remote Go debugger with vim-go
    vim.api.nvim_create_user_command('GoRemoteDebug', function(opts)
      local addr = opts.args ~= "" and opts.args or "127.0.0.1:40000"
      vim.cmd('GoDebugConnect ' .. addr)
    end, {
      nargs = '?',
      desc = 'Connect to remote Go debugger via vim-go (default: 127.0.0.1:40000)'
    })

    -- Command to quickly connect to default remote debugger
    vim.api.nvim_create_user_command('GoRemoteDebugDefault', function()
      vim.cmd('GoDebugConnect 127.0.0.1:40000')
    end, {
      desc = 'Connect to remote Go debugger at default address (127.0.0.1:40000)'
    })
  '';

  # Keymaps for vim-go remote debugging
  keymaps = [
    {
      mode = "n";
      key = "<leader>dgr";
      action = "<cmd>GoRemoteDebug<CR>";
      options = {
        desc = "Go: Connect to remote debugger (vim-go)";
      };
    }
    {
      mode = "n";
      key = "<leader>dgs";
      action = "<cmd>GoDebugStop<CR>";
      options = {
        desc = "Go: Stop debug session (vim-go)";
      };
    }
  ];
}

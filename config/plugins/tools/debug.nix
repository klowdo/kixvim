{
  # Shows how to use the DAP plugin to debug your code.
  #
  # Primarily focused on configuring the debugger for Go, but can
  # be extended to other languages as well. That's why it's called
  # kickstart.nixvim and not ktichen-sink.nixvim ;)
  # https://nix-community.github.io/nixvim/plugins/dap/index.html
  plugins = {
    dap = {
      enable = true;

      extensions = {
      };
    };
    dap-virtual-text = {
      enable = true;
    };

    # Creates a beautiful debugger UI
    dap-ui = {
      enable = true;

      settings = {
        # Set icons to characters that are more likely to work in every terminal.
        # Feel free to remove or use ones that you like more! :)
        # Don't feel like these are good choices.
        icons = {
          expanded = "▾";
          collapsed = "▸";
          current_frame = "*";
        };
        controls = {
          icons = {
            pause = "⏸";
            play = "▶";
            step_into = "⏎";
            step_over = "⏭";
            step_out = "⏮";
            step_back = "b";
            run_last = "▶▶";
            terminate = "⏹";
            disconnect = "⏏";
          };
        };
      };
    };

    # Add your own debuggers here
    dap-go = {
      enable = true;
      # Full dap-go configuration with test debugging support
      settings = {
        # Delve settings
        delve = {
          # Path to delve executable (defaults to "dlv" in PATH)
          path = "dlv";
          # Delve initialization timeout in seconds
          initialize_timeout_sec = 20;
          # Optional: specify a port for delve to listen on
          # port = "\${port}";
          # Build flags passed to delve
          build_flags = "";
          # Whether delve should run in detached mode (default true on Unix, false on Windows)
          # detached = true;
        };

        # Additional DAP configurations
        dap_configurations = [
          # Debug the current file/package
          {
            type = "go";
            name = "Debug Package";
            request = "launch";
            program = "\${fileDirname}";
          }
          # Debug the current test function
          {
            type = "go";
            name = "Debug Test (Current Function)";
            request = "launch";
            mode = "test";
            program = "\${fileDirname}";
          }
          # Debug the entire test file
          {
            type = "go";
            name = "Debug Test (Current File)";
            request = "launch";
            mode = "test";
            program = "\${file}";
          }
          # Remote debugging configuration
          {
            type = "go";
            name = "Attach to remote (port 40000)";
            mode = "remote";
            request = "attach";
            port = 40000;
            host = "127.0.0.1";
          }
        ];
      };
    };

    ## C  provide C, C++, and Rust debugging support.
    dap-lldb = {
      enable = true;
    };
  };

  # https://nix-community.github.io/nixvim/keymaps/index.html
  keymaps = [
    {
      mode = "n";
      key = "<F5>";
      action.__raw = ''
        function()
          require('dap').continue()
        end
      '';
      options = {
        desc = "Debug: Start/Continue";
      };
    }
    {
      mode = "n";
      key = "<F1>";
      action.__raw = ''
        function()
          require('dap').step_into()
        end
      '';
      options = {
        desc = "Debug: Step Into";
      };
    }
    {
      mode = "n";
      key = "<F2>";
      action.__raw = ''
        function()
          require('dap').step_over()
        end
      '';
      options = {
        desc = "Debug: Step Over";
      };
    }
    {
      mode = "n";
      key = "<F3>";
      action.__raw = ''
        function()
          require('dap').step_out()
        end
      '';
      options = {
        desc = "Debug: Step Out";
      };
    }
    {
      mode = "n";
      key = "<leader>b";
      action.__raw = ''
        function()
          require('dap').toggle_breakpoint()
        end
      '';
      options = {
        desc = "Debug: Toggle Breakpoint";
      };
    }
    {
      mode = "n";
      key = "<leader>B";
      action.__raw = ''
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end
      '';
      options = {
        desc = "Debug: Set Breakpoint";
      };
    }
    # Toggle to see last session result. Without this, you can't see session output
    # in case of unhandled exception.
    {
      mode = "n";
      key = "<F7>";
      action.__raw = ''
        function()
          require('dapui').toggle()
        end
      '';
      options = {
        desc = "Debug: See last session result.";
      };
    }
    # Go-specific DAP keymaps
    {
      mode = "n";
      key = "<leader>dgt";
      action.__raw = ''
        function()
          require('dap-go').debug_test()
        end
      '';
      options = {
        desc = "Debug: Go test at cursor";
      };
    }
    {
      mode = "n";
      key = "<leader>dgl";
      action.__raw = ''
        function()
          require('dap-go').debug_last_test()
        end
      '';
      options = {
        desc = "Debug: Go last test";
      };
    }
    # DAP remote Go debugging keymaps
    {
      mode = "n";
      key = "<leader>ddr";
      action = "<cmd>DapGoRemote<CR>";
      options = {
        desc = "Debug: Attach to remote Go process (DAP)";
      };
    }
    {
      mode = "n";
      key = "<leader>ddd";
      action = "<cmd>DapGoRemoteDefault<CR>";
      options = {
        desc = "Debug: Attach to remote Go at :40000 (DAP)";
      };
    }
  ];

  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraconfiglua#extraconfiglua
  extraConfigLua = ''
    require('dap').listeners.after.event_initialized['dapui_config'] = require('dapui').open
    require('dap').listeners.before.event_terminated['dapui_config'] = require('dapui').close
    require('dap').listeners.before.event_exited['dapui_config'] = require('dapui').close

    -- Custom command for DAP remote Go debugging
    vim.api.nvim_create_user_command('DapGoRemote', function(opts)
      local host = "127.0.0.1"
      local port = 40000

      -- Parse arguments if provided (format: host:port or just port)
      if opts.args ~= "" then
        local args = opts.args
        if args:match(":") then
          host, port = args:match("([^:]+):(%d+)")
          port = tonumber(port)
        else
          port = tonumber(args) or 40000
        end
      end

      local dap = require("dap")
      dap.run({
        type = "go",
        name = "Attach to remote Go process",
        mode = "remote",
        request = "attach",
        host = host,
        port = port,
      })

      print("Connecting to Go debugger at " .. host .. ":" .. port)
    end, {
      nargs = "?",
      desc = "Connect to remote Go debugger via DAP (default: 127.0.0.1:40000)"
    })

    -- Quick command for connecting to default remote debugger
    vim.api.nvim_create_user_command("DapGoRemoteDefault", function()
      local dap = require("dap")
      dap.run({
        type = "go",
        name = "Attach to remote Go process (40000)",
        mode = "remote",
        request = "attach",
        host = "127.0.0.1",
        port = 40000,
      })
      print("Connecting to Go debugger at 127.0.0.1:40000")
    end, {
      desc = "Connect to remote Go debugger at default address (127.0.0.1:40000)"
    })
  '';
}

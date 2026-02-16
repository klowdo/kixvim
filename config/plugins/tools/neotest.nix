{pkgs, ...}: {
  extraPackages = with pkgs; [
    netcoredbg
    go
    dotnet-sdk
  ];
  extraPlugins = with pkgs.vimPlugins; [
    FixCursorHold-nvim
    nvim-nio
    neotest-go
    neotest-dotnet
  ];

  plugins.neotest = {
    enable = true;
    settings = {
      output = {
        enabled = true;
        open_on_run = true;
      };
      output_panel = {
        enabled = true;
        open_on_run = true;
        open = "botright split | resize 15";
      };
      summary = {
        enabled = true;
      };
      quickfix = {
        enabled = true;
      };
      # Configure adapters directly with __raw Lua (must be a list)
      adapters = [
        {
          __raw = ''
            require('neotest-go')({
              recursive_run = true,
            })
          '';
        }
        {
          __raw = ''
            require('neotest-dotnet')({
              dap = {
                adapter_name = "netcoredbg",
              },
              discovery_root = "solution",
            })
          '';
        }
      ];
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>tt";
      action = "<cmd>lua require('neotest').run.run(vim.fn.expand '%')<CR>";
      options = {
        desc = "Run File";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tT";
      action = "<cmd>lua require('neotest').run.run(vim.loop.cwd())<CR>";
      options = {
        desc = "Run All Test Files";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tr";
      action = "<cmd>lua require('neotest').run.run()<CR>";
      options = {
        desc = "Run Nearest";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>td";
      action = "<cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>";
      options = {
        desc = "Run Nearest with debugger";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ts";
      action = "<cmd>lua require('neotest').summary.toggle()<CR>";
      options = {
        desc = "Toggle Summary";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>to";
      action = "<cmd>lua require('neotest').output.open{ enter = true, auto_close = true }<CR>";
      options = {
        desc = "Show Output";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tO";
      action = "<cmd>lua require('neotest').output_panel.toggle()<CR>";
      options = {
        desc = "Toggle Output Panel";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tS";
      action = "<cmd>lua require('neotest').run.stop()<CR>";
      options = {
        desc = "Stop";
        silent = true;
      };
    }
  ];
}

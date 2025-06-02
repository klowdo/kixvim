{pkgs, ...}: {
  extraPackages = with pkgs; [
    netcoredbg
  ];
  extraPlugins = with pkgs.vimPlugins; [
    FixCursorHold-nvim
    nvim-nio
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

        # open = function()
        # if LazyVim.has("trouble.nvim") then
        #   require("trouble").open({ mode = "quickfix", focus = false })
        # else
        #   vim.cmd("copen")
        # end
        # end,
      };
    };

    adapters = {
      go = {
        enable = true;
      };
      dotnet = {
        enable = true;
        settings = {
          # dap = {
          #      -- Extra arguments for nvim-dap configuration
          #      -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
          #        args = {justMyCode = false },
          #      -- Enter the name of your dap adapter, the default value is netcoredbg
          #        adapter_name = "netcoredbg"
          #      },
          #      -- Let the test-discovery know about your custom attributes (otherwise tests will not be picked up)
          #      -- Note: Only custom attributes for non-parameterized tests should be added here. See the support note about parameterized tests
          #      custom_attributes = {
          #        xunit = { "MyCustomFactAttribute" },
          #        nunit = { "MyCustomTestAttribute" },
          #        mstest = { "MyCustomTestMethodAttribute" }
          #      },
          #                ## -- Provide any additional "dotnet test" CLI commands here. These will be applied to ALL test runs performed via neotest. These need to be a table of strings, ideally with one key-value pair per item.
          #      dotnet_additional_args = {
          #        "--verbosity detailed"
          #      },
          #      -- Tell neotest-dotnet to use either solution (requires .sln file) or project (requires .csproj or .fsproj file) as project root
          #                ## -- Note: If neovim is opened from the solution root, using the 'project' setting may sometimes find all nested projects, however,
          #                  ## --       to locate all test projects in the solution more reliably (if a .sln file is present) then 'solution' is better.
          #      # discovery_root = "project" -- Default
          #    })
        };
      };
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

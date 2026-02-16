{pkgs, ...}: {
  extraPlugins = with pkgs; [
    qalc-nvim
  ];

  # Ensure libqalculate (provides qalc CLI) is available
  extraPackages = with pkgs; [
    libqalculate
  ];

  # File type associations for calculator files
  filetype = {
    extension = {
      qalc = "qalc";
      calc = "qalc";
    };
  };

  # Configure qalc.nvim
  extraConfigLua = ''
    -- Setup qalc.nvim with empty config table
    require('qalc').setup({})

    -- Auto-attach to qalc filetypes with proper highlighting
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "qalc",
      callback = function()
        -- Attach the calculator
        vim.cmd("QalcAttach")

        -- Set up syntax highlighting (qalc.nvim provides its own syntax)
        -- Ensure buffer gets the same highlighting as calculator buffers
        vim.opt_local.conceallevel = 0
        vim.opt_local.wrap = false

        -- Apply syntax from qalc.nvim if available
        local qalc_syntax = vim.fn.globpath(vim.o.runtimepath, "syntax/qalc.vim")
        if qalc_syntax ~= "" then
          vim.cmd("runtime! syntax/qalc.vim")
        end
      end,
      desc = "Auto-attach qalc calculator with syntax highlighting"
    })
  '';

  # Key mappings for qalc commands
  keymaps = [
    {
      mode = "n";
      key = "<leader>ko";
      action = "<cmd>Qalc<cr>";
      options = {
        desc = "Open qal[c] calculator buffer";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ka";
      action = "<cmd>QalcAttach<cr>";
      options = {
        desc = "Qal[c] [a]ttach to current buffer";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ky";
      action = "<cmd>QalcYank<cr>";
      options = {
        desc = "Qal[c] [y]ank result";
        silent = true;
      };
    }
  ];
}

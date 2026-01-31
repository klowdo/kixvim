{
  # [[ Basic Keymaps ]]
  #  See `:help vim.keymap.set()`
  # https://nix-community.github.io/nixvim/keymaps/index.html
  keymaps = [
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
    }
    # Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
    # for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
    # is not what someone will guess without a bit more experience.
    #
    # NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
    # or just use <C-\><C-n> to exit terminal mode
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
      options = {
        desc = "Exit terminal mode";
      };
    }
    # TIP: Disable arrow keys in normal mode
    /*
    {
      mode = "n";
      key = "<left>";
      action = "<cmd>echo 'Use h to move!!'<CR>";
    }
    {
      mode = "n";
      key = "<right>";
      action = "<cmd>echo 'Use l to move!!'<CR>";
    }
    {
      mode = "n";
      key = "<up>";
      action = "<cmd>echo 'Use k to move!!'<CR>";
    }
    {
      mode = "n";
      key = "<down>";
      action = "<cmd>echo 'Use j to move!!'<CR>";
    }
    */
    # Keybinds to make split navigation easier.
    #  Use CTRL+<hjkl> to switch between windows
    #
    #  See `:help wincmd` for a list of all window commands
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w><C-h>";
      options = {
        desc = "Move focus to the left window";
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w><C-l>";
      options = {
        desc = "Move focus to the right window";
      };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w><C-j>";
      options = {
        desc = "Move focus to the lower window";
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w><C-k>";
      options = {
        desc = "Move focus to the upper window";
      };
    }
    # Toggle diagnostics display modes
    {
      mode = "n";
      key = "<leader>td";
      action.__raw = ''
        function()
          local current_state = vim.diagnostic.config().virtual_text
          if current_state then
            -- If virtual_text is on, switch to virtual_lines
            vim.diagnostic.config({
              virtual_text = false,
              virtual_lines = true,
            })
            require('lsp_lines').toggle()
            vim.notify("Diagnostics: Virtual Lines", vim.log.levels.INFO)
          elseif vim.diagnostic.config().virtual_lines then
            -- If virtual_lines is on, switch to signs only
            vim.diagnostic.config({
              virtual_text = false,
              virtual_lines = false,
            })
            require('lsp_lines').toggle()
            vim.notify("Diagnostics: Signs Only", vim.log.levels.INFO)
          else
            -- If both are off, switch back to virtual_text
            vim.diagnostic.config({
              virtual_text = {
                severity = { min = vim.diagnostic.severity.WARN },
                source = "if_many",
              },
              virtual_lines = false,
            })
            vim.notify("Diagnostics: Virtual Text", vim.log.levels.INFO)
          end
        end
      '';
      options = {
        desc = "Toggle diagnostics display mode (virtual text/lines/signs)";
      };
    }
    {
      mode = "n";
      key = "<leader>tD";
      action.__raw = ''
        function()
          if vim.diagnostic.is_enabled() then
            vim.diagnostic.enable(false)
            vim.notify("Diagnostics: Disabled", vim.log.levels.INFO)
          else
            vim.diagnostic.enable(true)
            vim.notify("Diagnostics: Enabled", vim.log.levels.INFO)
          end
        end
      '';
      options = {
        desc = "Toggle diagnostics on/off completely";
      };
    }
    # Git root directory control
    {
      mode = "n";
      key = "<leader>cg";
      action.__raw = ''
        function()
          -- Change to git root directory
          local git_root = vim.fs.root(0, {".git", "_darcs", ".hg", ".bzr", ".svn"})
          if git_root then
            vim.cmd("cd " .. git_root)
            vim.notify("Changed to git root: " .. git_root, vim.log.levels.INFO)
          else
            vim.notify("No git repository found", vim.log.levels.WARN)
          end
        end
      '';
      options = {
        desc = "[C]hange to [G]it root directory";
      };
    }
    {
      mode = "n";
      key = "<leader>cD";
      action.__raw = ''
        function()
          -- Show current directory vs git root
          local current_dir = vim.fn.getcwd()
          local git_root = vim.fs.root(0, {".git", "_darcs", ".hg", ".bzr", ".svn"})

          if git_root then
            local current_relative = vim.fn.fnamemodify(current_dir, ":~")
            local git_relative = vim.fn.fnamemodify(git_root, ":~")

            if git_root == current_dir then
              vim.notify("✓ At git root: " .. git_relative, vim.log.levels.INFO)
            else
              vim.notify("Git root: " .. git_relative .. "\nCurrent: " .. current_relative, vim.log.levels.WARN)
            end
          else
            vim.notify("No git repository found\nCurrent: " .. vim.fn.fnamemodify(current_dir, ":~"), vim.log.levels.WARN)
          end
        end
      '';
      options = {
        desc = "Show [C]urrent vs git root [D]irectory status";
      };
    }
    {
      mode = "n";
      key = "<leader>cp";
      action.__raw = ''
        function()
          -- Change to parent directory of current file
          local current_file = vim.api.nvim_buf_get_name(0)
          if current_file ~= "" then
            local file_dir = vim.fn.fnamemodify(current_file, ":p:h")
            vim.cmd("cd " .. file_dir)
            vim.notify("Changed to file directory: " .. vim.fn.fnamemodify(file_dir, ":~"), vim.log.levels.INFO)
          else
            vim.notify("No file in current buffer", vim.log.levels.WARN)
          end
        end
      '';
      options = {
        desc = "[C]hange to current file's [P]arent directory";
      };
    }
    {
      mode = "n";
      key = "gx";
      action.__raw = ''
        function()
          local url_pattern = "https?://[%w-_%.%?%.:/%+=&%%#@!~]+"
          local file_pattern = "[%w_%.%-~/]+"
          local line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2] + 1

          local function find_at_cursor(pattern)
            local start_pos = 1
            while true do
              local match_start, match_end = line:find(pattern, start_pos)
              if not match_start then return nil end
              if col >= match_start and col <= match_end then
                return line:sub(match_start, match_end)
              end
              start_pos = match_end + 1
            end
          end

          local url = find_at_cursor(url_pattern)
          if url then
            vim.ui.open(url)
            return
          end

          local file = find_at_cursor(file_pattern)
          if file and vim.fn.filereadable(vim.fn.expand(file)) == 1 then
            vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.expand(file)))
            return
          end

          vim.notify("No URL or file under cursor", vim.log.levels.WARN)
        end
      '';
      options = {
        desc = "Open URL or file under cursor";
      };
    }
    {
      mode = "n";
      key = "<C-LeftMouse>";
      action.__raw = ''
        function()
          vim.cmd("normal! <LeftMouse>")
          vim.schedule(function()
            local url_pattern = "https?://[%w-_%.%?%.:/%+=&%%#@!~]+"
            local line = vim.api.nvim_get_current_line()
            local col = vim.api.nvim_win_get_cursor(0)[2] + 1

            local start_pos = 1
            while true do
              local match_start, match_end = line:find(url_pattern, start_pos)
              if not match_start then break end
              if col >= match_start and col <= match_end then
                vim.ui.open(line:sub(match_start, match_end))
                return
              end
              start_pos = match_end + 1
            end
          end)
        end
      '';
      options = {
        desc = "Ctrl+Click to open URL";
      };
    }
  ];
}

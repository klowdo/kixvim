{
  # Since vim-rooter is not available in nixvim, we'll implement root detection with pure Lua
  # Custom root directory detection and management

  # Custom Lua configuration for additional root detection logic
  extraConfigLua = ''
    -- Enhanced root directory detection function
    local function find_git_root()
      -- Start from current file's directory
      local current_file = vim.api.nvim_buf_get_name(0)
      local current_dir

      -- If current buffer is a file, start from its directory
      if current_file ~= "" then
        current_dir = vim.fn.fnamemodify(current_file, ":p:h")
      else
        -- If no file, start from current working directory
        current_dir = vim.fn.getcwd()
      end

      -- Use vim.fs.root (available in Neovim 0.10+) to find git root
      local git_root = vim.fs.root(current_dir, {".git", "_darcs", ".hg", ".bzr", ".svn"})

      if git_root then
        return git_root
      end

      -- Fallback to current directory if no git root found
      return current_dir
    end

    -- Function to change to git root
    function ChangeToGitRoot()
      local git_root = find_git_root()
      if git_root and git_root ~= vim.fn.getcwd() then
        vim.cmd("cd " .. git_root)
        vim.notify("Changed to git root: " .. git_root, vim.log.levels.INFO)
      else
        vim.notify("Already at git root: " .. vim.fn.getcwd(), vim.log.levels.INFO)
      end
    end

    -- Function to show current git root
    function ShowGitRoot()
      local git_root = find_git_root()
      local current_dir = vim.fn.getcwd()

      if git_root then
        local relative_path = vim.fn.fnamemodify(current_dir, ":~")
        local git_relative = vim.fn.fnamemodify(git_root, ":~")

        if git_root == current_dir then
          vim.notify("✓ At git root: " .. git_relative, vim.log.levels.INFO)
        else
          vim.notify("Git root: " .. git_relative .. "\nCurrent: " .. relative_path, vim.log.levels.WARN)
        end
      else
        vim.notify("No git root found", vim.log.levels.WARN)
      end
    end

    -- Auto-command to change to git root when opening files
    vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
      group = vim.api.nvim_create_augroup("AutoGitRoot", { clear = true }),
      callback = function()
        -- Skip for special buffers (terminals, file explorers, etc.)
        local buftype = vim.bo.buftype
        local filetype = vim.bo.filetype

        -- Skip for non-file buffers
        if buftype ~= "" or filetype == "neo-tree" or filetype == "TelescopePrompt" then
          return
        end

        local git_root = find_git_root()
        if git_root and git_root ~= vim.fn.getcwd() then
          vim.cmd("silent cd " .. git_root)
        end
      end,
    })
  '';

  # keymaps = [
  #   {
  #     mode = "n";
  #     key = "<leader>cr";
  #     action = "<cmd>lua ChangeToGitRoot()<cr>";
  #     options = {
  #       desc = "[C]hange to git [R]oot";
  #       silent = true;
  #     };
  #   }
  #   {
  #     mode = "n";
  #     key = "<leader>cR";
  #     action = "<cmd>lua ShowGitRoot()<cr>";
  #     options = {
  #       desc = "Show git [R]oot status";
  #       silent = true;
  #     };
  #   }
  # ];
}

{
  plugins.auto-session = {
    enable = true;
    settings = {
      # Include terminal in session options for proper terminal recovery
      session_lens = {
        load_on_setup = true;
      };

      # Ensure terminals are saved and restored properly
      pre_save_cmds = [
        # Close any floating windows before saving to avoid issues
        "lua for _, win in ipairs(vim.api.nvim_list_wins()) do local config = vim.api.nvim_win_get_config(win); if config.relative ~= '' then vim.api.nvim_win_close(win, false) end end"
      ];

      # Disable vim-dadbod auto-completion during session restore to prevent DB connection errors
      pre_restore_cmds = [
        "let g:db_ui_auto_execute_table_helpers = 0"
        "let g:vim_dadbod_completion_skip_fetch = 1"
      ];

      post_restore_cmds = [
        # Restore terminal functionality after session load
        "lua vim.defer_fn(function() for _, buf in ipairs(vim.api.nvim_list_bufs()) do if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == 'terminal' then vim.api.nvim_buf_call(buf, function() vim.cmd('startinsert') vim.cmd('stopinsert') end) end end end, 100)"
        # Re-enable vim-dadbod completion after session restore
        "let g:db_ui_auto_execute_table_helpers = 1"
        "let g:vim_dadbod_completion_skip_fetch = 0"
      ];
    };
  };

  # Set session options to include terminal and current directory for proper recovery
  opts.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";

  # Additional configuration for git root preservation
  extraConfigLua = ''
    -- Function to get git root for session management
    local function get_session_git_root()
      local git_root = vim.fs.root(0, {".git", "_darcs", ".hg", ".bzr", ".svn"})
      return git_root or vim.fn.getcwd()
    end

    -- Enhanced session handling with git root awareness
    vim.api.nvim_create_autocmd("User", {
      pattern = "AutoSessionSavePre",
      callback = function()
        -- Ensure we're in the correct directory before saving session
        local git_root = get_session_git_root()
        if git_root ~= vim.fn.getcwd() then
          vim.cmd("cd " .. git_root)
        end

        -- Store the git root in a global variable for restoration
        vim.g.session_git_root = git_root
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "AutoSessionRestorePost",
      callback = function()
        -- Restore to git root after session load
        local git_root = vim.g.session_git_root or get_session_git_root()

        -- Change to git root if we're not already there
        if git_root ~= vim.fn.getcwd() then
          vim.cmd("cd " .. git_root)
        end

        -- Clean up the global variable
        vim.g.session_git_root = nil
      end,
    })

    -- Auto-save session when leaving directories
    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function()
        -- Auto-save current session before changing directories
        if vim.fn.argc() > 0 then  -- Only if files were opened
          local session_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          pcall(vim.cmd, "SessionSave " .. session_name)
        end
      end,
    })
  '';
}

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

      post_restore_cmds = [
        # Restore terminal functionality after session load
        "lua vim.defer_fn(function() for _, buf in ipairs(vim.api.nvim_list_bufs()) do if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == 'terminal' then vim.api.nvim_buf_call(buf, function() vim.cmd('startinsert') vim.cmd('stopinsert') end) end end end, 100)"
      ];
    };
  };

  # Set session options to include terminal for proper recovery
  opts.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";
}

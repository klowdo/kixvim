{
  # extraPlugins = with pkgs; [
  #   overseer-nvim
  # ];

  # extraConfigLua = ''
  #   require('overseer').setup({
  #     task_list = {
  #       direction = "bottom",
  #       min_height = 25,
  #       max_height = 25,
  #       default_detail = 1,
  #     },
  #   })
  # '';
  plugins.overseer = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>or";
      action = "<cmd>OverseerRun<CR>";
      options = {
        desc = "[O]verseer [R]un";
      };
    }
    {
      mode = "n";
      key = "<leader>ot";
      action = "<cmd>OverseerToggle<CR>";
      options = {
        desc = "[O]verseer [T]oggle";
      };
    }
    {
      mode = "n";
      key = "<leader>oa";
      action = "<cmd>OverseerTaskAction<CR>";
      options = {
        desc = "[O]verseer Task [A]ction";
      };
    }
    {
      mode = "n";
      key = "<leader>oi";
      action = "<cmd>OverseerInfo<CR>";
      options = {
        desc = "[O]verseer [I]nfo";
      };
    }
    {
      mode = "n";
      key = "<leader>oq";
      action = "<cmd>OverseerQuickAction<CR>";
      options = {
        desc = "[O]verseer [Q]uick action";
      };
    }
    {
      mode = "n";
      key = "<leader>ol";
      action.__raw = ''
        function()
          local overseer = require('overseer')
          local tasks = overseer.list_tasks({ recent_first = true })
          if tasks[1] then
            local task = tasks[1]
            vim.notify("Running: " .. task.name, vim.log.levels.INFO)
            task:restart()
          else
            vim.notify("No tasks found", vim.log.levels.WARN)
          end
        end
      '';
      options = {
        desc = "[O]verseer run [L]ast task";
      };
    }
  ];
}

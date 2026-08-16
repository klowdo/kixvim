{pkgs, ...}: {
  # https://github.com/atiladefreitas/dooing
  extraPlugins = with pkgs; [
    dooing
  ];

  extraConfigLua = ''
    -- dooing ships a `plugin/dooing.vim` that calls `setup()` with the upstream
    -- defaults, which would register `<leader>td`/`<leader>tD` on top of the
    -- existing [T]oggle mappings. Claim the load guard and configure it here.
    vim.g.loaded_dooing = 1

    require('dooing').setup({
      per_project = {
        enabled = true,
        default_filename = "dooing.json",
        auto_gitignore = "prompt",
      },
      keymaps = {
        -- Global mappings, the rest are buffer local to the todo window
        toggle_window = "<leader>xd",
        open_project_todo = "<leader>xp",
        show_due_notification = "<leader>xu",
      },
    })
  '';
}

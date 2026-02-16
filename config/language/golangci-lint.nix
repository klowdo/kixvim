{
  extraConfigLua = ''
    vim.api.nvim_create_user_command('GolangciLint', function()
      vim.cmd('setlocal makeprg=golangci-lint\\ run\\ --output.text.path=stdout\\ --output.text.colors=false')
      vim.cmd('setlocal errorformat=%f:%l:%c:\\ %m,%f:%l:\\ %m,%-G%.%#')
      vim.cmd('make!')
      vim.cmd('copen')
    end, {})
  '';

  keymaps = [
    {
      key = "<leader>gil";
      action = ":GolangciLint<CR>";
      mode = "n";
      options.desc = "Run golangci-lint";
    }
  ];
}

{pkgs, ...}: {
  extraPlugins = with pkgs; [
    atone-nvim
  ];

  extraConfigLua = ''
    require('atone').setup({
      diff_cur_node = {
        split_percent = 0.6,
        width = "adaptive",
      },
    })
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>u";
      action = "<cmd>Atone toggle<CR>";
      options = {
        desc = "Toggle Atone undo tree";
        silent = true;
      };
    }
  ];
}

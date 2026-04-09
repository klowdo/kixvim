{
  plugins.tv = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>tv";
      action = "<cmd>Tv<CR>";
      options = {
        desc = "[T]ele[v]ision channel picker";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tf";
      action = "<cmd>Tv files<CR>";
      options = {
        desc = "[T]elevision [f]iles";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tg";
      action = "<cmd>Tv text<CR>";
      options = {
        desc = "[T]elevision [g]rep text";
        silent = true;
      };
    }
  ];
}

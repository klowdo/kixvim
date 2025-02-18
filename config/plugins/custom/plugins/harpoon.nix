{
  plugins.harpoon = {
    enable = true;
    enableTelescope = true;
    keymapsSilent = true;

    saveOnChange = true;
    saveOnToggle = true;
    keymaps = {
      addFile = "<leader>ha";
      toggleQuickMenu = "<C-e>";
      navFile = {
        "1" = "<leader>hj";
        "2" = "<leader>hk";
        "3" = "<leader>hl";
        "4" = "<leader>hm";
      };
    };
  };
}

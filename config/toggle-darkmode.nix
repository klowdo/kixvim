{
  keymaps = [
    {
      mode = "n";
      key = "<leader>tp"; # Press <leader>tt to toggle theme
      action = ":lua ToggleTheme()<CR>";
      options = {
        desc = "Toggle between light and dark theme";
        silent = true;
      };
    }
  ];
  opts = {
    background = "dark"; # Default to dark mode
  };

  # Lua function to handle the toggle
  extraConfigLua = ''
    -- Function to toggle between light and dark mode
    function ToggleTheme()
      if vim.o.background == "dark" then
        vim.o.background = "light"
        print("Switched to light mode")
      else
        vim.o.background = "dark"
        print("Switched to dark mode")
      end
    end

    -- Optional: Set up autocmd to persist theme choice
    -- This saves the current background setting
    local theme_group = vim.api.nvim_create_augroup("ThemeToggle", { clear = true })
    vim.api.nvim_create_autocmd("OptionSet", {
      group = theme_group,
      pattern = "background",
      callback = function()
        -- You can add logic here to save the preference if needed
      end,
    })
  '';
}

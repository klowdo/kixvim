{
  # inc-rename.nvim - Incremental LSP renaming with live preview
  # https://github.com/smjonas/inc-rename.nvim
  #
  # Features:
  # - Edit the identifier name incrementally instead of replacing entirely
  # - See live preview of all renames as you type
  # - Works with any LSP server (gopls, lua_ls, etc.)
  # - Integrates with snacks.input for a nice UI
  #
  # Usage:
  # - Position cursor on an identifier
  # - Press <leader>cr (or your chosen keymap)
  # - Edit the name in the input box
  # - Press <CR> to apply, <Esc> to cancel

  plugins.inc-rename = {
    enable = true;

    settings = {
      # Command name for the rename operation
      cmd_name = "IncRename";

      # Highlight group for the identifier being renamed
      hl_group = "Substitute";

      # Show empty preview when no new name is entered yet
      preview_empty_name = false;

      # Show a message after renaming is complete
      show_message = true;

      # Save rename commands in command-line history
      save_in_cmdline_history = false;

      # Use snacks for input - passed as raw Lua since nixvim schema only knows about "dressing"
      # input_buffer_type.__raw = "snacks';

      # Optional: Hook to run after rename completes
      # post_hook = null;
    };
  };

  # Workaround for FileExplorer autocmd error (E216)
  # Ensure the FileExplorer group exists to avoid errors with inc-rename preview
  extraConfigLuaPre = ''
    pcall(vim.api.nvim_create_augroup, "FileExplorer", { clear = false })
  '';

  keymaps = [
    # Use IncRename Lua API directly to avoid potential autocmd issues
    # This uses snacks input with live preview
    {
      mode = "n";
      key = "<leader>cr";
      action.__raw = ''
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end
      '';
      options = {
        desc = "Rename with live preview";
        expr = true;
        silent = false;
      };
    }
  ];
}

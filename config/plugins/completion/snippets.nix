{...}: {
  # Enhanced LuaSnip Configuration
  # https://nix-community.github.io/nixvim/plugins/luasnip/index.html

  # `friendly-snippets` contains a variety of premade snippets
  # See the README about individual language/framework/plugin snippets:
  # https://github.com/rafamadriz/friendly-snippets
  plugins.friendly-snippets.enable = true;

  # Required Lua package for LuaSnip regex support
  extraLuaPackages = ps: [ps.jsregexp];

  plugins.luasnip = {
    enable = true;

    settings = {
      # Enable autotriggered snippets
      enable_autosnippets = true;

      # Use Tab to jump through snippet nodes
      store_selection_keys = "<Tab>";

      # Update snippets as you type
      update_events = "TextChanged,TextChangedI";

      # Delete snippet when jumping backwards
      delete_check_events = "TextChanged";

      # History navigation
      history = true;

      # Extended filetypes
      ext_opts = {
        __raw = ''
          {
            [require("luasnip.util.types").choiceNode] = {
              active = {
                virt_text = { { "●", "DiagnosticWarn" } }
              }
            },
            [require("luasnip.util.types").insertNode] = {
              active = {
                virt_text = { { "●", "DiagnosticInfo" } }
              }
            }
          }
        '';
      };
    };
  };

  # Add cmp-luasnip for better integration
  plugins.cmp_luasnip.enable = true;

  # Load Go snippets from external file
  extraConfigLuaPre = builtins.readFile ./snippets/go.lua;

  # Enhanced snippet keybindings
  extraConfigLua = ''
    local ls = require("luasnip")

    -- Load friendly-snippets (VSCode-style snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Add Go snippets (loaded from go.lua via extraConfigLuaPre)
    if go_snippets then
      ls.add_snippets("go", go_snippets)
      vim.notify("Loaded " .. #go_snippets .. " Go snippets", vim.log.levels.INFO)
    else
      vim.notify("Warning: go_snippets not found!", vim.log.levels.WARN)
    end

    -- Debug command to list available snippets
    vim.api.nvim_create_user_command('SnippetsList', function()
      local ft = vim.bo.filetype
      local available = ls.get_snippets(ft)
      if available and next(available) then
        print("Available snippets for " .. ft .. ":")
        for _, snip in ipairs(available) do
          print("  - " .. snip.trigger .. ": " .. (snip.name or ""))
        end
      else
        print("No snippets available for filetype: " .. ft)
      end
    end, { desc = 'List available snippets for current filetype' })

    -- Jump forward in snippet
    vim.keymap.set({"i", "s"}, "<C-k>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, {silent = true, desc = "Expand or jump forward in snippet"})

    -- Jump backward in snippet
    vim.keymap.set({"i", "s"}, "<C-j>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, {silent = true, desc = "Jump backward in snippet"})

    -- Change choice in choice node
    vim.keymap.set({"i", "s"}, "<C-e>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, {silent = true, desc = "Change choice in snippet"})
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>sl";
      action = "<cmd>SnippetsList<CR>";
      options = {
        desc = "List available snippets";
      };
    }
  ];
}

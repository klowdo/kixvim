{pkgs, ...}: {
  # Dependencies
  #
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extrapackages
  extraPackages = with pkgs; [
    # Used to format Lua code
    stylua
    nixfmt-rfc-style
    alejandra
    clang-tools
    shfmt
    fixjson
  ];

  # Autoformat
  # https://nix-community.github.io/nixvim/plugins/conform-nvim.html
  plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = {
        lua = ["stylua"];
        bash = ["shfmt"];
        nix = {
          __unkeyed-1 = "alejandra";
          __unkeyed-2 = "nixfmt";
          stop_after_first = true;
        };
        c = ["clang-format"];

        json = "fixjson";

        "_" = {
          __unkeyed-1 = "squeeze_blanks";
          __unkeyed-2 = "trim_whitespace";
          __unkeyed-3 = "trim_newlines";
        };
      };
      # source https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#autoformat-with-extra-features
      format_on_save =
        # Lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            local function on_format(err)
              if err and err:match("timeout$") then
                slow_format_filetypes[vim.bo[bufnr].filetype] = true
              end
            end

            return { timeout_ms = 200, lsp_fallback = true }, on_format
           end
        '';
      format_after_save =
        # Lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if not slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            return { lsp_fallback = true }
          end
        '';
      log_level = "warn";
      notify_on_error = true;
      notify_no_formatters = true;
    };

    # https://nix-community.github.io/nixvim/keymaps/index.html
  };

  keymaps = [
    {
      mode = "";
      key = "<leader>f";
      action.__raw = ''
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end
      '';
      options = {desc = "[F]ormat buffer";};
    }
  ];

  # extraFiles= { "conform/toggle.lua".text =
  #         # Lua
  #       ''
  #      vim.api.nvim_create_user_command("FormatDisable", function(args)
  #        if args.bang then
  #          -- FormatDisable! will disable formatting just for this buffer
  #          vim.b.disable_autoformat = true
  #        else
  #          vim.g.disable_autoformat = true
  #        end
  #      end, {
  #        desc = "Disable autoformat-on-save",
  #        bang = true,
  #      })
  #      vim.api.nvim_create_user_command("FormatEnable", function()
  #        vim.b.disable_autoformat = false
  #        vim.g.disable_autoformat = false
  #      end, {
  #        desc = "Re-enable autoformat-on-save",
  #      })
  #     '';
  # };
}

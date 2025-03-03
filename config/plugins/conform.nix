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
              -- Disable autoformat on certain filetypes
              local ignore_filetypes = { "sql", "java" }
              if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
                return
              end
              -- Disable with a global or buffer-local variable
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end
              -- Disable autoformat for files in a certain path
              local bufname = vim.api.nvim_buf_get_name(bufnr)
              if bufname:match("/node_modules/") then
                return
              end
             -- ...additional logic...
              return { timeout_ms = 500, lsp_format = "fallback" }
            end
        '';
      format_after_save =
        # Lua
        ''
           function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            -- ...additional logic...
            return { lsp_format = "fallback" }
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

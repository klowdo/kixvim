{pkgs, ...}: {
  # Rust development configuration
  #
  # Features:
  # - LSP integration (rust-analyzer)
  # - Code formatting (rustfmt)
  # - Linting (clippy)
  # - Test support
  # - Debug support with DAP
  # - Cargo integration

  # Add Rust development tools
  extraPackages = with pkgs; [
    # Core Rust toolchain
    cargo
    rustc
    rustfmt
    clippy
    rust-analyzer

    # Additional tools
    cargo-watch
    cargo-expand
    cargo-edit
  ];

  # Keymaps for Rust development
  keymaps = [
    # Cargo commands
    {
      mode = "n";
      key = "<leader>rb";
      action = "<cmd>!cargo build<CR>";
      options = {
        desc = "Rust: Cargo build";
      };
    }
    {
      mode = "n";
      key = "<leader>rr";
      action = "<cmd>!cargo run<CR>";
      options = {
        desc = "Rust: Cargo run";
      };
    }
    {
      mode = "n";
      key = "<leader>rt";
      action = "<cmd>!cargo test<CR>";
      options = {
        desc = "Rust: Run tests";
      };
    }
    {
      mode = "n";
      key = "<leader>rc";
      action = "<cmd>!cargo check<CR>";
      options = {
        desc = "Rust: Cargo check";
      };
    }
    {
      mode = "n";
      key = "<leader>rl";
      action = "<cmd>!cargo clippy<CR>";
      options = {
        desc = "Rust: Run clippy";
      };
    }
    {
      mode = "n";
      key = "<leader>ru";
      action = "<cmd>!cargo update<CR>";
      options = {
        desc = "Rust: Cargo update";
      };
    }
    {
      mode = "n";
      key = "<leader>rd";
      action = "<cmd>!cargo doc --open<CR>";
      options = {
        desc = "Rust: Open documentation";
      };
    }
    {
      mode = "n";
      key = "<leader>re";
      action = "<cmd>!cargo expand<CR>";
      options = {
        desc = "Rust: Expand macros";
      };
    }

    # Crate management
    {
      mode = "n";
      key = "<leader>ra";
      action = "<cmd>!cargo add ";
      options = {
        desc = "Rust: Add dependency";
      };
    }
  ];

  # Additional Rust-specific configuration
  extraConfigLua = ''
    -- Auto-format on save for Rust files using rustfmt
    local rust_format_grp = vim.api.nvim_create_augroup("RustFormat", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.rs",
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
      group = rust_format_grp,
    })

    -- Show inlay hints for Rust files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = function()
        vim.lsp.inlay_hint.enable(true)
      end,
    })
  '';
}

{
  # ThePrimeagen's refactoring.nvim
  # https://github.com/ThePrimeagen/refactoring.nvim
  # Refactoring library based on Martin Fowler's Refactoring book

  plugins.refactoring = {
    enable = true;
    enableTelescope = true;
    settings = {
      prompt_func_return_type = {
        go = true;
      };
      prompt_func_param_type = {
        go = true;
      };
      printf_statements = {
        cpp = ["std::cout << \"%s\" << std::endl;"];
      };
      print_var_statements = {
        cpp = ["printf(\"a custom statement %%s %s\", %s)"];
      };
      extract_var_statements = {
        go = "%s := %s // poggers";
      };
      show_success_message = true;
    };
  };

  keymaps = [
    # Extract function in visual mode
    {
      mode = ["n" "x"];
      key = "<leader>re";
      action = "<cmd>Refactor extract<cr>";
      options = {
        desc = "[R]efactor [E]xtract Function";
      };
    }
    # Extract function to separate file
    {
      mode = ["x"];
      key = "<leader>rf";
      action.__raw = "function() require('refactoring').refactor('Extract Function To File') end";
      options = {
        desc = "[R]efactor Extract [F]unction To File";
      };
    }
    # Extract variable in visual mode
    {
      mode = ["x"];
      key = "<leader>rv";
      action.__raw = "function() require('refactoring').refactor('Extract Variable') end";
      options = {
        desc = "[R]efactor Extract [V]ariable";
      };
    }
    # Inline variable in normal and visual mode
    {
      mode = ["n" "x"];
      key = "<leader>ri";
      action.__raw = "function() require('refactoring').refactor('Inline Variable') end";
      options = {
        desc = "[R]efactor [I]nline Variable";
      };
    }
    # Extract block (normal mode)
    {
      mode = ["n"];
      key = "<leader>rb";
      action.__raw = "function() require('refactoring').refactor('Extract Block') end";
      options = {
        desc = "[R]efactor Extract [B]lock";
      };
    }
    # Extract block to file (normal mode)
    {
      mode = ["n"];
      key = "<leader>rB";
      action.__raw = "function() require('refactoring').refactor('Extract Block To File') end";
      options = {
        desc = "[R]efactor Extract [B]lock To File";
      };
    }
    # Inline function (normal mode)
    {
      mode = ["n"];
      key = "<leader>rI";
      action.__raw = "function() require('refactoring').refactor('Inline Function') end";
      options = {
        desc = "[R]efactor [I]nline Function";
      };
    }
    # Debug print variable (normal mode)
    {
      mode = ["n"];
      key = "<leader>rp";
      action.__raw = "function() require('refactoring').debug.print_var() end";
      options = {
        desc = "[R]efactor Debug [P]rint Variable";
      };
    }
    # Debug print variable (visual mode)
    {
      mode = ["x"];
      key = "<leader>rp";
      action.__raw = "function() require('refactoring').debug.print_var() end";
      options = {
        desc = "[R]efactor Debug [P]rint Variable";
      };
    }
    # Debug cleanup
    {
      mode = ["n"];
      key = "<leader>rc";
      action.__raw = "function() require('refactoring').debug.cleanup() end";
      options = {
        desc = "[R]efactor Debug [C]leanup";
      };
    }
  ];
}

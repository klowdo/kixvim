{...}: {
  plugins.primes-99 = {
    enable = true;
    settings = {
      provider.__raw = ''require("99").Providers.ClaudeCodeProvider'';
      provider_extra_args = ["--no-session-persistence"];
      tmp_dir = "/tmp/99";
    };
  };

  keymaps = [
    {
      mode = "v";
      key = "<leader>9v";
      action.__raw = ''function() require("99").visual() end'';
      options.desc = "99 Visual";
    }
    {
      mode = "n";
      key = "<leader>9x";
      action.__raw = ''function() require("99").stop_all_requests() end'';
      options.desc = "99 Stop requests";
    }
    {
      mode = "n";
      key = "<leader>9s";
      action.__raw = ''function() require("99").search() end'';
      options.desc = "99 Search";
    }
  ];
}

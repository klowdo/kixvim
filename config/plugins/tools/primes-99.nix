{lib, ...}: let
  inherit (lib.nixvim) defaultNullOpts;
in
  lib.nixvim.plugins.mkNeovimPlugin {
    name = "primes-99";
    package = ["primes-99"];
    moduleName = "99";

    maintainers = [];

    settingsOptions = {
      provider = lib.mkOption {
        type = lib.types.rawLua;
        default.__raw = ''require("99").Providers.OpenCodeProvider'';
      };

      model = defaultNullOpts.mkStr null ''
        Override the default model for the provider.
      '';

      provider_extra_args = defaultNullOpts.mkListOf lib.types.str [] ''
        Extra arguments passed to the provider CLI command.
      '';

      display_errors = defaultNullOpts.mkBool false ''
        Display errors in the UI.
      '';

      md_files = defaultNullOpts.mkListOf lib.types.str [] ''
        List of markdown files to auto-add based on request location.
      '';

      tmp_dir = defaultNullOpts.mkStr null ''
        Temporary directory for 99 operations.
      '';

      completion = {
        source = defaultNullOpts.mkEnumFirstDefault ["cmp" "blink"] ''
          Completion source to use.
        '';

        custom_rules = defaultNullOpts.mkListOf lib.types.str [] ''
          Directories containing custom SKILL.md files.
        '';
      };
    };

    settingsExample = {
      provider.__raw = ''require("99").Providers.ClaudeCodeProvider'';
      provider_extra_args = ["--no-session-persistence"];
      md_files = ["AGENT.md"];
      completion = {
        source = "cmp";
      };
    };
  }

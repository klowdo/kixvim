{...}: {
  extraLuaPackages = ps: [ps.lua-utils-nvim ps.pathlib-nvim];

  # https://nix-community.github.io/nixvim/plugins/neorg/index.html
  plugins.neorg = {
    enable = false;
    settings = {
      telescopeIntegration.enable = true;
      load = {
        "core.concealer" = {
          config = {
            icon_preset = "varied";
          };
        };
        "core.defaults" = {
          __empty = null;
        };
        "core.journal" = {
          __empty = null;
        };

        "core.completion" = {
          config = {
            engine = "nvim-cmp";
          };
        };
        "core.dirman" = {
          config = {
            workspaces = {
              home = "~/notes/home";
              work = "~/notes/work";
              school = "~/notes/school";
            };
            default_workspace = "school";
          };
        };
      };
    };
  };
}

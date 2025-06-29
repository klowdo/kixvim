{pkgs, ...}: {
  extraPackages = [pkgs.mermaid-cli pkgs.plantuml pkgs.d2 pkgs.gnuplot];
  plugins.diagram = {
    enable = true;
    settings = {
      integrations = [
        {
          __raw = "require('diagram.integrations.markdown')";
        }
        {
          __raw = "require('diagram.integrations.neorg')";
        }
      ];
      renderer_options = {
        d2 = {
          theme_id = 1;
        };
        gnuplot = {
          size = "800,600";
          theme = "dark";
        };
        mermaid = {
          theme = "forest";
        };
        plantuml = {
          charset = "utf-8";
        };
      };
    };
  };
}

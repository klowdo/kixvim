{pkgs, ...}: {
  plugins.wakatime = {
    enable = true;
  };

  extraPackages = [pkgs.wakatime-cli];
}

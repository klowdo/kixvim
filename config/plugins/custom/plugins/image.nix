{pkgs, ...}: {
  # https://nix-community.github.io/nixvim/plugins/image/index.html
  extraLuaPackages = ps: [ps.magick];
  extraPackages = [pkgs.imagemagick];
  plugins.image = {
    enable = true;
  };
}

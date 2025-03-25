{pkgs, ...}: {
  extraPackages = with pkgs; [
    sshfs
  ];

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "remote-sshfs";
      dependencies = [pkgs.vimPlugins.telescope-nvim];
      src = pkgs.fetchFromGitHub {
        owner = "nosduco";
        repo = "remote-sshfs.nvim";
        rev = "03f6c40c4032eeb1ab91368e06db9c3f3a97a75d";
        hash = "sha256-vFEIISxhTIGSl9LzDYHuEIkjLGkU0y5XhfWI/i5DgN4=";
      };
    })
  ];
  extraConfigLua = "require('remote-sshfs').setup({})";
}

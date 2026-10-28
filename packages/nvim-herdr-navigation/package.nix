{
  inputs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "nvim-herdr-navigation";
  src = "${inputs.nvim-herdr-navigation}/nvim-herdr-navigation";
  version = inputs.nvim-herdr-navigation.shortRev;
}

{
  inputs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "atone-nvim";
  src = inputs.atone-nvim;
  version = inputs.atone-nvim.shortRev;
}

{
  inputs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "qalc-nvim";
  src = inputs.qalc-nvim;
  version = inputs.qalc-nvim.shortRev;
}

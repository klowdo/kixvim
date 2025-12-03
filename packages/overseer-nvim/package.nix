{
  inputs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "overseer-nvim";
  src = inputs.overseer-nvim;
  version = "1.6.0";
}

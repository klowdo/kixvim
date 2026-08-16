{
  inputs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "dooing";
  src = inputs.dooing;
  version = inputs.dooing.shortRev;
}

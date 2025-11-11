{
  inputs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "guihua-lua";
  src = inputs.guihua-lua;
  version = inputs.guihua-lua.shortRev;

  nvimSkipModule = [
    "guihua.ts_obsolete.query"
    "guihua.ts_obsolete.tsrange"
    "guihua.ts_obsolete.fold"
    "guihua.ts_obsolete.locals"
    "guihua.ts_obsolete.ts_utils"
    "guihua.ts_obsolete.parsers"
    "fzy.fzy-lua-native"
    "fzy.native"
  ];
}

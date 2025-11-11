{
  inputs,
  pkgs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "snacks-nvim";
  src = inputs.snacks-nvim;
  version = inputs.snacks-nvim.shortRev;

  dependencies = [pkgs.vimPlugins.trouble-nvim];

  nvimSkipModule = [
    "snacks.dashboard"
    "snacks.indent"
    "snacks.input"
    "snacks.notifier"
    "snacks.picker.actions"
    "snacks.picker.config.highlights"
    "snacks.picker.util.db"
    "snacks.terminal"
    "snacks.win"
    "snacks.zen"
    "snacks.dim"
    "snacks.git"
    "snacks.lazygit"
    "snacks.scratch"
    "snacks.scroll"
    "snacks.words"
    "snacks.picker.core.list"
    "snacks.image"
    "snacks.image.init"
    "snacks.image.placement"
    "snacks.image.image"
    "snacks.image.convert"
    "snacks.explorer.init"
    "snacks.gh.init"
    "snacks.gh.buf"
    "snacks.gh.render.init"
    "snacks.gh.actions"
    "snacks.picker.source.gh"
    "snacks.picker.util.diff"
  ];
}

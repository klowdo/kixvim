{
  inputs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "go-nvim";
  src = inputs.go-nvim;
  version = inputs.go-nvim.shortRev;

  nvimSkipModule = [
    "init"
    "go.ginkgo"
    "go.fixplurals"
    "go.project"
    "go.snips"
    "go.gotest"
    "go.null_ls"
    "go.format"
    "go.comment"
    "go.gotests"
    "go.tags"
    "go.ts.nodes"
    "go.ts.utils"
    "go.ts.go"
    "snips.all"
    "snips.go"
  ];
}

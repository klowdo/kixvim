{
  plugins.copilot-lua = {
    enable = false;
    settings = {
      suggestion.enabled = false; # Since you're using copilot-cmp
      panel.enabled = false;
      filetypes = {
        yaml = true;
        markdown = true;
        help = false;
        gitcommit = false;
        gitrebase = false;
        hgcommit = false;
        svn = false;
        cvs = false;
        "." = false;
      };
    };
  };
}

{
  pre-commit.settings.hooks = {
    # ========== General ==========
    check-case-conflicts.enable = true;
    check-merge-conflicts.enable = true;
    detect-private-keys.enable = true;
    fix-byte-order-marker.enable = true;
    mixed-line-endings.enable = true;
    trim-trailing-whitespace.enable = true;

    # ========== nix ==========
    alejandra.enable = true;
    deadnix = {
      enable = true;
      settings = {
        noLambdaArg = true;
      };
    };

    # ========== shellscripts ==========
    shfmt.enable = true;
    shellcheck.enable = true;
    end-of-file-fixer.enable = true;
  };
}

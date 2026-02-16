{pkgs, ...}: {
  # https://nix-community.github.io/nixvim/plugins/clipboard-image/index.html
  plugins.clipboard-image = {
    enable = true;
    clipboardPackage = pkgs.wl-clipboard;
  };

  # Fix health check API compatibility issue
  extraConfigLuaPre = ''
    -- Fix deprecated health check API in clipboard-image plugin
    local orig_health = vim.health or {}
    if not orig_health.report_start and orig_health.start then
      vim.health = vim.health or {}
      vim.health.report_start = orig_health.start
      vim.health.report_ok = orig_health.ok
      vim.health.report_warn = orig_health.warn
      vim.health.report_error = orig_health.error
      vim.health.report_info = orig_health.info
    end
  '';
}

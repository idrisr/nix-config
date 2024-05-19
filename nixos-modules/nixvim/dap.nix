{
  programs.nixvim.plugins.dap = {
    enable = true;
    extensions = {
      dap-ui.enable = true;
      dap-virtual-text.enable = true;
    };
    signs.dapBreakpoint.text = "🔴";
  };
}

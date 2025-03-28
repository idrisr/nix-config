{ pkgs, ... }:

{
  config = {
    programs.vscode = {

      profiles.default.extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        ms-vscode.cpptools

      ];

      enable = false;

      profiles.default.keybindings = [
        {
          key = "ctrl+h";
          command = "workbench.action.navigateLeft";
        }
        {
          key = "ctrl+l";
          command = "workbench.action.navigateRight";
        }
        {
          key = "ctrl+k";
          command = "workbench.action.navigateUp";
        }
        {
          key = "ctrl+j";
          command = "workbench.action.navigateDown";
        }
      ];
    };
  };
}

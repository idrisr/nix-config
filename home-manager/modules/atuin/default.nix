{
  config = {
    programs.atuin = {
      enable = true;

      daemon.enable = false;
      flags = [ "--disable-up-arrow" ];
      settings = {
        filter_mode_shell_up_key_binding = "session";
        inline_height = 30;
        enter_accept = false;
      };
    };
  };
}

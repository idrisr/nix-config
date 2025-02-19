{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [ sway alacritty wayland-utils ];

  users.users.youruser = {
    isNormalUser = true;
    password = "asdf";
    extraGroups = [ "sudo" "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.sway.enable = true;
  programs.zsh.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "sway";
      user = "youruser";
    };
  };
}

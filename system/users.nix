{ pkgs, ... }: {
  config = {
    programs.zsh.enable = true;
    users.users.hippoid = {
      isNormalUser = true;
      description = "hippoid";
      extraGroups =
        [ "audio" "dialout" "docker" "networkmanager" "wheel" "lpadmin" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        (builtins.readFile ./public-keys/id_rsa.pub)
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0cwEynaFR5ZsIcKlV/3Ca1vUFg3YJ/3+Gv7l0YVVjZ root@surface"
      ];
    };
  };
}

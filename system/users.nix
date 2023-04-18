{ pkgs, ... }: {
  config = {
    programs.zsh.enable = true;
    users.users.hippoid = {
      isNormalUser = true;
      description = "hippoid";
      extraGroups = [ "docker" "networkmanager" "wheel" "lpadmin" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        (builtins.readFile ./public-keys/id_rsa.pub)
        (builtins.readFile ./public-keys/id_rsa-ipad.pub)
      ];
    };
  };
}

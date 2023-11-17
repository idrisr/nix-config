{ pkgs, ... }: {
  config = {
    programs.zsh.enable = true;
    users.groups = { fuse = { }; };
    users.users.hippoid = {
      isNormalUser = true;
      description = "hippoid";
      extraGroups = [
        "audio"
        "dialout"
        "docker"
        "fuse"
        "lpadmin"
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys =
        [ (builtins.readFile ./public-keys/id_rsa.pub) ];
    };
  };
}

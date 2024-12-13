{ pkgs, ... }: {
  config = {
    programs.zsh.enable = true;
    users.users.hippoid = {
      isNormalUser = true;
      description = "hippoid";
      extraGroups = [
        "sudo"
        "audio"
        "dialout"
        "docker"
        "lpadmin"
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.zsh;
      hashedPassword =
        "$y$j9T$AtpzctqNX9eOED3dkj1es/$gAwm9CkJRZolwuv9kC4CGlXd7znho1EqmcJJZHum6d5";
      openssh.authorizedKeys.keys = [
        (builtins.readFile ./public-keys/id_ed25519.pub)
        (builtins.readFile ./public-keys/id_ed25519-framework.pub)
      ];
    };
  };
}

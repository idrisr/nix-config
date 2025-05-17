{ pkgs, config, ... }: {
  config = {
    programs.zsh.enable = true;

    sops.defaultSopsFile = ../secrets.yaml;

    sops = {
      secrets."users/hippoid/hashedPassword" = {
        owner = "root";
        mode = "0400";
        neededForUsers = true;
      };

      age.keyFile = "/var/lib/sops/age/key.txt";
    };

    users.mutableUsers = false;

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
      hashedPasswordFile =
        config.sops.secrets."users/hippoid/hashedPassword".path;

      openssh.authorizedKeys.keys = [
        (builtins.readFile ./public-keys/id_ed25519.pub)
        (builtins.readFile ./public-keys/id_ed25519-framework.pub)
      ];
    };
  };
}

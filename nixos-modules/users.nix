{ pkgs, config, ... }: {
  config = {
    programs.zsh.enable = true;
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

      hashedPassword =
        "$y$j9T$BowmS9BT0LZ5WNT1V4Day1$dae0REqJAJuNehr7b3Uj3Zy.dToJ30mwOqugbA39b02";

      openssh.authorizedKeys.keys = [
        (builtins.readFile ./public-keys/id_ed25519.pub)
        (builtins.readFile ./public-keys/id_ed25519-framework.pub)
      ];
    };
  };
}

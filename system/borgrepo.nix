{ config, pkgs, ... }: {
  config = {
    users.users.borg = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0cwEynaFR5ZsIcKlV/3Ca1vUFg3YJ/3+Gv7l0YVVjZ root@surface"
      ];
    };
    services.borgbackup.repos = {
      my_borg_repo = {
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0cwEynaFR5ZsIcKlV/3Ca1vUFg3YJ/3+Gv7l0YVVjZ root@surface"
        ];
      };
    };
  };
}

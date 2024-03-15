{
  config = {
    services.borgbackup.repos = {
      my_borg_repo02 = {
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP69Fws6+Hku+8ez7RC8Ln9kJGGiSI/9a72JP2wVoYUP root@surface"
        ];
        path = "/var/lib/borgbackup02";
        user = "borg";
      };
    };
  };
}

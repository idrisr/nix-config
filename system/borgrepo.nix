{ config, pkgs, ... }: {
  config = {
    users.users.hippoid = {
      openssh.authorizedKeys.keys =
        [ (builtins.readFile ./public-keys/id_rsa.pub) ];
    };
  };
}

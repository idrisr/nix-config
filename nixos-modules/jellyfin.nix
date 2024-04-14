{ pkgs, ... }: {
  config = {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
    users.users.jellyfin = {
      description = "jellyfin";
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys =
        [ (builtins.readFile ./public-keys/jellyfin_ed25519.pub) ];
    };
  };
}

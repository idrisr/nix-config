{ config, pkgs, ... }: {
  # https://github.com/reflex-frp/reflex-platform/blob/develop/notes/NixOS.md
  config = {
    nix = {
      settings = {
        trusted-substituters = [ "https://nixcache.reflex-frp.org" ];
        trusted-public-keys =
          [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
      };
    };
  };
}

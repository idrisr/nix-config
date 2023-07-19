{ config, pkgs, lib, ... }: {
  config = { services = { printing = { enable = true; }; }; };
}

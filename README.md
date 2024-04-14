# Nix Config

My nix flake-based config for nixos on all my machines.

For home manager, I can create a set M of modules.
Within those modules I can declare options N to extend the home-manager options
P. Then there will be an option set P // N=Q.  From that set Q I can then create
profiles which effectively create subsets of Q. Those subsets will likely have
semantic meaning like -- headless, laptop, work, demo, etc.

To put the modules into their semantic sets, I see at least two different
possibilities.

1) Import all of the modules, meaning import every module. Those modules that
are imported must have their config behind an option declaration like so

```
  options = {
    networking.adblocker = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable adguard on port 3000
        '';
      };
    };
  };
```

2) selectively import modules that don't have their config behind a declared
option. This is the more primitive form, but also serves as a nice intermediate
step before moving all modules to an option based system. But really, is it that
much work to put all the modules behind an option? Because the options only need
to exist to create the subsets needed. For example

```
  options = {
    minimum = {
      enable = mkOption {
        default = true;
        type = types.bool;
        description = lib.mdDoc ''
            enable the basic tools needed for a user for some usable system
        '';
      };
    };

    dailydriver = {
      enable = mkOption {
        default = true;
        type = types.bool;
        description = lib.mdDoc ''
            enable the full tools needed for a user for some banging system
        '';
      };
    };
  };
```

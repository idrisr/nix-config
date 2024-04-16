# Book Launcher

There are two packages here that I want composed together
    A --- rofi shell script
    B --- desktop icon

A+B should be treated as a unit. Both will need to be separate overalys injected
into the nixpkgs attribute set.

To treat A+B atomically, I can declare an nixos module option, C, which controls
the composite A+B.

## Option 1
If C is enabled, then A+B will be injected as overlays, and added the list of
environment packages.

## Option 2
If C is enabled, then use pkgs.callPackage A {} and pkgs.callPackage B {}
directly. No need to overlay them into nixpkgs first.

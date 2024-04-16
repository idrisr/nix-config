# Intention

I want both the home-manager neovim ("A") and the nixvim neovim ("B") available
at the same time. The reason I want both is that getting B up-to-snuff requires
lots of editing, and that's too difficult when B is not yet up-to-snuff---a
bootstrapping problem.

## Hypothesis

Setting both A and B to enable in the nixos config makes it such that only A is
reachable. I *think* it's because while both are being built and put into the
current profile, A appears first when searching for nvim in the list of $PATH directories.

### Result
yep. B is in 10, while A is in 8.

💦33% 🟢 0 ➜ echo ${PATH//:/\\n} | cat -n
     1  /nix/store/gd3shnza1i50zn8zs04fa729ribr88m9-python3-3.11.8/bin
     2  /nix/store/jyb26xhnxn3chf4k3nlxjs6fcnkipg7v-tmuxp-1.45.0/bin
     3  /nix/store/78p9q6yw4z9dskj1zx3djkrwxlyzm62s-python3.11-kaptan-0.6.0/bin
     4  /run/wrappers/bin
     5  /home/hippoid/.nix-profile/bin
     6  /nix/profile/bin
     7  /home/hippoid/.local/state/nix/profile/bin
     8  /etc/profiles/per-user/hippoid/bin
     9  /nix/var/nix/profiles/default/bin
    10  /run/current-system/sw/bin

# Fix
We can either get at B directly from its path, which is a kind-of cave-man
solution. A more debonair black-tie solution is to wrap a neovim package from
nixpkgs, and then change its name, call that package C. Then we set the nixvim
pkg attribute to be the new one. good plan.

## chain
    shell
    env
    path
    profile
    nix store path
    nix store object
    nix store derivation
    nix expression
    nix module

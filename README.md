# dotfiles

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

![Example 01](https://github.com/mrioqueiroz/dotfiles/raw/master/setup-01.png)
![Example 02](https://github.com/mrioqueiroz/dotfiles/raw/master/setup-02.png)

- Theme: [Gruvbox](https://github.com/morhetz/gruvbox)
- Dotfiles manager: [YADM](https://yadm.io/).

## Neovim

- [Plugins](https://github.com/mrioqueiroz/dotfiles/blob/master/.config/nixpkgs/home.nix)
- [Configuration](https://github.com/mrioqueiroz/dotfiles/blob/master/.config/nixpkgs/init.vim)
- [Templates](https://github.com/mrioqueiroz/dotfiles/tree/master/.vim/templates)

## tmux

- [Plugins](https://github.com/mrioqueiroz/dotfiles/blob/master/.config/nixpkgs/home.nix)
- [Configuration](https://github.com/mrioqueiroz/dotfiles/blob/master/.config/nixpkgs/tmux.conf)

## Distributed build

Since I am using two computers with the same configuration, one acts as build
cache for the other, so I don't need to compile anything twice.
I still don't know if this is the best way to configure it, but this seems to
be working well:

```nix
{
 nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = if config.networking.hostName == "nixos-02" then "01-builder" else "02-builder";
        system = "x86_64-linux";
        maxJobs = 8;
        speedFactor = 3;
        sshUser = "root";
      }
    ];
    extraOptions = ''
      connect-timeout = 5
      max-jobs = 8
      max-silent-time = 240
      builders-use-substitutes = false
      fallback = true
      substitute = true
      substituters = ${if config.networking.hostName == "nixos-02" then "01-builder" else "02-builder"} https://cache.nixos.org
    '';
  };
}
```

## Backup

The backup is managed by Restic. The computer `02` sends the files to the
computer `01` via SFTP, and the computer `01` saves the files to an external
SSD. The SSD is automatically mounted by `systemd`. This process is defined
here:

- [`nixos-01`](https://github.com/mrioqueiroz/dotfiles/blob/master/configuration.nix%23%23h.nixos-01)
- [`nixos-02`](https://github.com/mrioqueiroz/dotfiles/blob/master/configuration.nix%23%23h.nixos-02)

## Notes

This repository is kind of a mirror of my actual dotfiles, as the original
repository is not public yet.

## Basic demonstration

[![Demo](https://img.youtube.com/vi/FCuui7N6jvM/0.jpg)](https://www.youtube.com/watch?v=FCuui7N6jvM)

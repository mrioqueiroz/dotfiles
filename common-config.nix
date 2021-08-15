{ config, pkgs, ... }:
let
  sshKeys = [
  ];
in {

  boot = {
    loader = {
      systemd-boot = { enable = true; };
      efi = { canTouchEfiVariables = true; };
    };
    cleanTmpDir = false;
    kernelModules = [
      "v4l2loopback"
    ];
    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback
    ];
  };

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    firmware = [ pkgs.sof-firmware ];
    bluetooth = { enable = false; };
    trackpoint = {
      enable = true;
      speed = 130;
      emulateWheel = true;
    };
    deviceTree = { enable = true; };
    pulseaudio = {
      enable = true;
      support32Bit = true;
      package = pkgs.pulseaudioFull;
      systemWide = false;
      tcp = { enable = true; };
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = false;
      dates = if config.networking.hostName == "nixos-02" then "04:00" else "daily";
      randomizedDelaySec = "45min";
    };
  };

  systemd = {
    services = {
      gromit = {
        enable = true;
        description = "gromit-mpx";
        environment = {
          DISPLAY = ":0";
          XDG_CURRENT_DESKTOP = "none+xmonad";
        };
        wantedBy = [ "multi-user.target" ];
        after = [ "display-manager.service" ];
        partOf = [ "graphical.target" ];
        startLimitBurst = 10;
        startLimitIntervalSec = 300;
        serviceConfig = {
          Type = "simple";
          User = "mario";
          ExecStart = "/run/current-system/sw/bin/gromit-mpx";
          Restart = "always";
          RestartSec = 30;
        };
      };
    };
  };

  time = {
    timeZone = "America/Sao_Paulo";
    hardwareClockInLocalTime = true;
  };

  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
      volumeStep = "5%";
    };
  };

  powerManagement = { enable = true; };

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;
    users = {
      mario = {
        isNormalUser = true;
        useDefaultShell = true;
        home = "/home/mario";
        extraGroups = [ "wheel" "vboxusers" "docker" "audio" "volume" ];
        hashedPassword =
          "";
        openssh = {
          authorizedKeys = { keys = sshKeys; };
        };
      };
    };
    users = {
      root = {
        isSystemUser = true;
        openssh = {
          authorizedKeys = { keys = sshKeys; };
        };
      };
    };
  };

  i18n = { defaultLocale = "en_US.UTF-8"; };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "prohibit-password";
      allowSFTP = true;
      extraConfig = ''
        PermitUserEnvironment yes
      '';
    };
    cron = {
      enable = true;
      systemCronJobs = [
        "0 0 1 * * mario docker system prune --all --force"
      ];
    };

    lorri = { enable = true; };

    xserver = {
      enable = true;
      layout = "br";
      xrandrHeads = [ "HDMI-1" "eDP-1" ];
      xkbOptions = "caps:ctrl_modifier";
      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = hpkgs: [
            hpkgs.xmonad
            hpkgs.xmonad-contrib
            hpkgs.xmonad-extras
          ];
        };
      };
      displayManager = { xpra = { pulseaudio = true; }; };
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
        };
        mouse = {
          naturalScrolling = true;
        };
      };
      displayManager = {
        defaultSession = "none+xmonad";
        lightdm = { enable = true; };
      };
      desktopManager = {
        wallpaper = {
          mode = "fill";
          combineScreens = false;
        };
      };
    };

    acpid = { enable = true; };

    gnome = { gnome-keyring = { enable = true; }; };

    printing = { enable = true; };

    actkbd = {
      enable = true;
      bindings = [
        {
          keys = [ 224 ];
          events = [ "key" ];
          command = "/run/current-system/sw/bin/light -U 10";
        }
        {
          keys = [ 225 ];
          events = [ "key" ];
          command = "/run/current-system/sw/bin/light -A 10";
        }
      ];
    };

    headphones = { enable = true; };

    jack = {
      alsa = {
        enable = true;
        support32Bit = false;
      };
      loopback = { enable = false; };
    };

    upower = {
      enable = true;
      usePercentageForPolicy = true;
      criticalPowerAction = "HybridSleep";
      percentageCritical = 10;
    };

    clipmenu = { enable = true; };

    picom = {
      enable = true;
      fade = false;
      shadow = true;
      fadeDelta = 1;
      activeOpacity = 1.0;
      inactiveOpacity = 0.92;
      menuOpacity = 1.0;
      shadowOffsets = [ (-15) (-15) ];
      vSync = false;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
  };

  nix = {
    trustedUsers = [ "root" "mario" "@wheel" ];
    buildCores = if config.networking.hostName == "nixos-02" then 4 else 2;
    nrBuildUsers = 40;
    autoOptimiseStore = true;
    optimise = { automatic = true; dates = [ "03:00" "11:00" ]; };
    gc = {
      automatic = if config.networking.hostName == "nixos-02" then true else false;
      dates = "monthly";
      options = "--delete-older-than 10d";
    };
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

  virtualisation = {
    docker = { enable = true; };
    virtualbox = {
      host = {
        enable = true;
        enableHardening = true;
        addNetworkInterface = true;
        enableExtensionPack = true;
        headless = false;
      };
      guest = {
        enable = true;
      };
    };
  };

  programs = {
    gnupg = { agent = { enable = true; }; };
    bash = { enableCompletion = true; };
    vim = { defaultEditor = true; };
    slock = { enable = true; };
    light = { enable = true; };
    java = { enable = true; };
    ssh = {
      extraConfig = builtins.readFile "/home/mario/.ssh/config";
    };
  };

  fonts = { fonts = with pkgs; [ nerdfonts ]; };

  networking = {
    useDHCP = false;
  };

  environment = {
    variables = {
      BROWSER = "/run/current-system/sw/bin/firefox";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      DOCKER_BUILDKIT = "1";
    };
    shellInit = ''
      xcape -e "Caps_Lock=Escape"
    '';
    systemPackages = with pkgs; [
      alacritty # A cross-platform, GPU-accelerated terminal emulator
      azure-cli # Next generation multi-platform command line experience for Azure
      bat # A cat(1) clone with syntax highlighting and Git integration
      broot # An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands
      clang # A c, c++, objective-c, and objective-c++ frontend for the llvm compiler (wrapper script)
      cmake # Cross-Platform Makefile Generator
      colordiff # Wrapper for 'diff' that produces the same output but with pretty 'syntax' highlighting
      direnv # A shell extension that manages your environment
      docker-compose # Multi-container orchestration for Docker
      exa # Replacement for 'ls' written in Rust
      fd # A simple, fast and user-friendly alternative to find
      firefox # A web browser built from Firefox source tree (with plugins: )
      flameshot # Powerful yet simple to use screenshot software
      gcc # GNU Compiler Collection, version 9.3.0 (wrapper script)
      gdb # The GNU Project debugger
      ghc # The Glasgow Haskell Compiler
      ghcid # GHCi based bare bones IDE
      gitAndTools.delta # A syntax-highlighting pager for git
      gitAndTools.gitFull # Distributed version control system
      gitAndTools.gitflow # Extend git with the Gitflow branching model
      gitAndTools.gitui # Blazing fast terminal-ui for git written in rust
      gnumake # A tool to control the generation of non-source files from sources
      go-tools # A collection of tools and libraries for working with Go code, including linters and static analysis
      gromit-mpx # Desktop annotation tool
      haskellPackages.hoogle
      haskellPackages.xmobar
      home-manager # A user environment configurator
      htop # An interactive process viewer for Linux
      irssi # A terminal based IRC client
      jq # A lightweight and flexible command-line JSON processor
      kubectl # Kubernetes CLI
      manix # A Fast Documentation Searcher for Nix
      mkpasswd # Overfeatured front-end to crypt, from the Debian whois package
      nixopsUnstable # NixOS cloud provisioning and deployment tool
      ranger # File manager with minimalistic curses interface
      ripgrep # A utility that combines the usability of The Silver Searcher with the raw speed of grep
      ripgrep-all # Ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, and more
      starship # A minimal, blazing fast, and extremely customizable prompt for any shell
      terraform # Tool for building, changing, and versioning infrastructure
      tmuxp # Manage tmux workspaces from JSON and YAML
      tree # Command to produce a depth indented directory listing
      unrar # Utility for RAR archives
      unzip # An extraction utility for archives compressed in .zip format
      wget # Tool for retrieving files using HTTP, HTTPS, and FTP
      xorg.xev
      xorg.xmodmap
      yadm # Yet Another Dotfiles Manager
      zathura # A highly customizable and functional PDF viewer
      zip # Compressor/archiver for creating and modifying zipfiles
      zoxide # A fast cd command that learns your habits
    ];
  };
}

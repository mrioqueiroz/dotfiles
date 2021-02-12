{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = false;

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  hardware.firmware = [ pkgs.sof-firmware ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = false;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  sound.enable = true;
  sound.mediaKeys.enable = true;
  sound.mediaKeys.volumeStep = "5%";
  powerManagement.enable = true;

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

  services.picom.enable = true;
  services.picom.fade = true;
  services.picom.shadow = false;
  services.picom.fadeDelta = 4;
  services.picom.activeOpacity = 1.0;
  services.picom.inactiveOpacity = 0.93;
  services.picom.menuOpacity = 1.0;
  services.picom.shadowOffsets = [ (-15) (-15) ];
  services.picom.vSync = false;

  services.gnome3.gnome-keyring.enable = true;
  services.printing.enable = true;
  services.xserver.enable = true;
  services.xserver.layout = "br";
  services.xserver.libinput.enable = true;
  services.xserver.libinput.naturalScrolling = true;
  services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.wallpaper.mode = "fill";
  services.xserver.windowManager = {
    xmonad.enable = true;
    xmonad.enableContribAndExtras = true;
    xmonad.extraPackages = hpkgs: [
      hpkgs.xmonad
      hpkgs.xmonad-contrib
      hpkgs.xmonad-extras
    ];
  };
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
    ];
  };

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;
  security.pam.services.mario.enableGnomeKeyring = true;

  users.users.mario = {
    isNormalUser = true;
    home = "/home/mario";
    description = "Mário";
    extraGroups = [ "wheel" "vboxusers" "docker" "audio" "volume" ];
    hashedPassword = "$2$aMFxfg0KyI$ojA8lkfa84qlulaf9q5q35#RQw4FAsg5WŸw%$QT4b50Rm/24L7nqdGViRIeD0NsNqegF.w6TWGnKm/";
    openssh.authorizedKeys.keys = [
      "ssh-rsa QkJBQUI0TnphQzF5YzJFKUFERERMwMDk3OHFsFdBNmowMWlNLzQ3VEN6U29UVzdzK0dWdU9memRNZlA2TVRuL015NWZkeElPMHVLY2Voa1p1dVNnZUR6QkBzSkMyNXRPR1d4YXpvaTVSTC9HOEpUNGVkUGR4TUFIWittWGlFaDE5N1kzOGVwZ2VCa1ZheVQzYnpINm9TbnMxeWQrR2swTE9YblRZZlgxcHFuekVvY0NkRFpnNHIvMnE2VVpRbHc3N3ZkSjNVRlU5Y1VvMTYrdjBhRFl3PT9K email@email.com"
      ];
  };

  networking.hostName = "nixos-pc";
  networking.useDHCP = false;
  networking.firewall.enable = true;
  networking.firewall.allowPing = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.wireless = {
    enable = true;
    interfaces = [ ];
    userControlled.enable = true;
    userControlled.group = "wheel";
    networks = {
      "Home WiFi" = {
        priority = 1;
        pskRaw = "7532672bb7770c812d9ab0611a61e556907e832864134734b8d3e7d87579334f";
      };
      "Coworking" = {
        priority = 2;
        pskRaw = "df1f6d6aadf393b3ea554be12b63a27284a83485c151555481e271edcd9f5a7a";
      };
    };
  };  

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;
  environment.systemPackages = with pkgs; [
    alacritty
    bash-completion
    bat
    cron
    dmenu
    exa
    fd
    fzf
    ghc
    ghcid
    gitAndTools.gitFull
    gitAndTools.gitui
    haskellPackages.xmobar
    home-manager
    htop 
    mkpasswd
    psmisc
    pwgen
    stack
    starship
    tree
    unzip 
    wget
    yadm
  ];

  fonts.fonts = with pkgs; [
    nerdfonts
  ];

  programs.bash.enableCompletion = true;
  programs.vim.defaultEditor = true;
  programs.slock.enable = true;
  programs.tmux.enable = false;
  programs.light.enable = true;
  programs.java.enable = true;

  environment.shellAliases = {
    c = "clear";
    e = "exit";
    q = "exit";
    h = "history";
    j = "jobs -l";
    o = "xdg-open";
    ll = "exa -lhag -H --git --icons";
  };
  environment.variables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    BROWSER = "/run/current-system/sw/bin/firefox";
  };

  system.stateVersion = "20.03";
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-20.09";
  system.autoUpgrade.dates = "05:30";
}

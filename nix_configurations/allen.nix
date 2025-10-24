{ config, pkgs, ... }:

let
  # https://channels.nixos.org/?prefix=nixpkgs-unstable/
  # https://nixos.wiki/wiki/Nix_Hash
  unstableTarball = builtins.fetchTarball { url = "https://github.com/NixOS/nixpkgs/archive/d5faa84122bc0a1fd5d378492efce4e289f8eac1.tar.gz"; sha256 = "0r2pkx7m1pb0fzfhb74jkr8y5qhs2b93sak5bd5rabvbm2zn36zs"; };
  pkgs-unstable = import unstableTarball { config.allowUnfree = true; };
in
{
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users = {
    defaultUserShell = pkgs.zsh;

    users.allen = {
      isNormalUser = true;
      description = "allen";
      extraGroups = [ "networkmanager" "wheel" ];

      packages = (with pkgs-unstable; [
        brave
        discord
        ffmpeg
        fzf
        git
        keepassxc
        mpv
        obs-studio
        (python313.withPackages (ps: [ ps.cryptography ]))
        qbittorrent
        ripgrep
        signal-desktop
        spotdl
        vscodium-fhs
        wireshark
        xournalpp
        yt-dlp
      ]) ++ (with pkgs; []);
    };
  };

  environment = {
    systemPackages = with pkgs; [
      curl
      htop
      lm_sensors
      lsof
      man-pages
      man-pages-posix
      neovim
      wget
      wl-clipboard
    ];

    plasma6.excludePackages = with pkgs.kdePackages; [ elisa kate ];
  };

  programs = {
    gnome-disks.enable = true;
    localsend.enable = true;
    zsh.enable = true;
  };

  services = {
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

    xserver = {
      enable = false;
      xkb.layout = "us";
      xkb.variant = "";
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    keyd = {
      enable = true;
      keyboards.default.settings.main.capslock = "overload(control, noop)";
    };
  };

  hardware.bluetooth.enable = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";
  };

  security.rtkit.enable = true;
}

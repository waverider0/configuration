{ config, pkgs, ... }:

let
  # https://github.com/NixOS/nixpkgs/commits/nixpkgs-unstable
  # nix-prefetch-url --unpack --name nixpkgs-<commit_hash> "https://github.com/NixOS/nixpkgs/archive/<commit_hash>.tar.gz"
  pkgs-unstable-tgz = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/0d59e0290eefe0f12512043842d7096c4070f30e.tar.gz";
    sha256 = "04a03ffnjc2y22460n01djgvqgkrnmm02kqhrlzpd3wwjjbz3bb7";
  };
  pkgs-unstable = import pkgs-unstable-tgz { config.allowUnfree = true; };
in
{
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "25.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;

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

  programs = {
    git.enable = true;
    gnome-disks.enable = true;
    localsend.enable = true;
    neovim.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      albert
      binutils
      clang
      cloc
      curl
      fzf
      htop
      linuxPackages.perf
      lm_sensors
      lsof
      man-pages
      man-pages-posix
      moreutils
      pciutils
      perf-tools
      ripgrep
      wget
      wl-clipboard
    ];
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      kate
    ];
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.allen = {
      isNormalUser = true;
      description = "allen";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = (with pkgs-unstable; [
        age
        alacritty
        brave
        discord
        ffmpeg
        kdePackages.kdenlive
        keepassxc
        mpv
        neofetch
        obs-studio
        pinta
        popsicle
        (python313.withPackages (ps: [
          ps.cryptography
          ps.ipykernel
          ps.matplotlib
          ps.numpy
          ps.requests
          ps.scipy
          ps.sympy
          ps.z3-solver
        ]))
        qbittorrent
        signal-desktop
        spotdl
        spotify
        tree
        unrar
        vscodium-fhs
        wireshark
        xournalpp
        yt-dlp
        zed-editor-fhs
      ]) ++ (with pkgs; []);
    };
  };

  system.activationScripts.kwinShortcuts = ''
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file /home/allen/.config/kcminputrc --group Keyboard --key RepeatDelay "250"
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file /home/allen/.config/kcminputrc --group Keyboard --key RepeatRate "25"
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file /home/allen/.config/kglobalshortcutsrc --group kwin --key "Overview" "none,none,Toggle Overview"
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file /home/allen/.config/kglobalshortcutsrc --group kwin --key "Window Close" "Meta+W,Alt+F4,Close Window"
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file /home/allen/.config/kglobalshortcutsrc --group kwin --key "Window Maximize" "Meta+F,Meta+PgUp,Maximize Window"
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file /home/allen/.config/kglobalshortcutsrc --group kwin --key "Window Minimize" "Meta+M,Meta+PgDown,Minimize Window"
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file /home/allen/.config/kglobalshortcutsrc --group services --group Alacritty.desktop --key "_launch" "Ctrl+Alt+T${"\t"}Meta+Return"
  '';
}

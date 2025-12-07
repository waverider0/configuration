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

  environment = {
    systemPackages = with pkgs; [
      binutils
      linuxPackages.perf
      man-pages
      man-pages-posix
      pciutils
      perf-tools
    ];
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.allen = {
      isNormalUser = true;
      description = "allen";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = (with pkgs-unstable; [
        discord
        kdePackages.kdenlive
        obs-studio
        pinta
        popsicle
        qbittorrent
        signal-desktop
        spotdl
        spotify
        wireshark
        xournalpp
        yt-dlp
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

{ config, ... }:

let
  # https://channels.nixos.org/
  # https://nixos.wiki/wiki/Nix_Hash
  pkgs-tgz = builtins.fetchTarball { url = "https://github.com/NixOS/nixpkgs/archive/95ec937f47c15392185aafd64480dc128f8a80bd.tar.gz"; sha256 = "05lpdk9d0ry4fjq06p77v6qv5mh69ss93pmrc0gflhi0a0y4xzrw"; };
  pkgs-unstable-tgz = builtins.fetchTarball { url = "https://github.com/NixOS/nixpkgs/archive/d5faa84122bc0a1fd5d378492efce4e289f8eac1.tar.gz"; sha256 = "0r2pkx7m1pb0fzfhb74jkr8y5qhs2b93sak5bd5rabvbm2zn36zs"; };

  pkgs = import pkgs-tgz { config.allowUnfree = true; };
  pkgs-unstable = import pkgs-unstable-tgz { config.allowUnfree = true; };
in
{
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "25.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
    gnome-disks.enable = true;
    localsend.enable = true;
    zsh.enable = true;
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
        neofetch
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

  system.activationScripts.kwinShortcuts = ''
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file /home/allen/.config/kglobalshortcutsrc --group kwin --key "Overview" "none,none,Toggle Overview"
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file /home/allen/.config/kglobalshortcutsrc --group kwin --key "Window Close" "Meta+W,Alt+F4,Close Window"
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file /home/allen/.config/kglobalshortcutsrc --group kwin --key "Window Maximize" "Meta+F,Meta+PgUp,Maximize Window"
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file /home/allen/.config/kglobalshortcutsrc --group kwin --key "Window Minimize" "Meta+M,Meta+PgDown,Minimize Window"
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file /home/allen/.config/kglobalshortcutsrc --group services --group org.kde.konsole.desktop --key "_launch" "Ctrl+Alt+T${"\t"}Meta+Return"
  '';
}

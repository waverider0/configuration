{ config, pkgs, pkgs-unstable, ... }:

{
   imports = [
      ../common.nix
      ./hardware-configuration.nix
      ./virtualisation.nix
   ];

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

         packages = (with pkgs; [
            brave
            discord
            ffmpeg
            fzf
            keepassxc
            mpv
            obs-studio
            (python313.withPackages (ps: [ ps.cryptography ]))
            qbittorrent
            ripgrep
            signal-desktop
            spotdl
            spotify
            wireshark
            yt-dlp
         ]) ++ (with pkgs-unstable; []);
      };
   };

   environment = {
      systemPackages = (with pkgs; [
         lm_sensors
         lsof
         man-pages
         man-pages-posix
         wl-clipboard
      ]) ++ (with pkgs-unstable; []);

      plasma6.excludePackages = with pkgs.kdePackages; [
         elisa
         kate
         konsole
      ];
   };

   programs = {
      gnome-disks.enable = true;
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

{ pkgs, ... }:

{
   environment.systemPackages = with pkgs; [
      curl
      git
      htop
      universal-ctags
      vim
      wget
   ];
}

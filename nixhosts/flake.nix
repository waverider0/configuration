{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }: {
    nixosConfigurations = {
      # cd nixhosts
      # sudo nixos-rebuild switch --flake .#allen
      "allen" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./allen/configuration.nix ];
        specialArgs = { pkgs-unstable = import nixpkgs-unstable { system = "x86_64-linux"; config.allowUnfree = true; }; };
      };
    };
  };
}

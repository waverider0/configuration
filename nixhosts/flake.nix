{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }: {
    nixosConfigurations = {
      "nixpc" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/nixpc/configuration.nix ];
        specialArgs = { pkgs-unstable = import nixpkgs-unstable { system = "x86_64-linux"; config.allowUnfree = true; }; };
      };
    };
  };
}

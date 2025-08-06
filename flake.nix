{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-25.05/nixexprs.tar.xz";
    nixpkgs-unstable.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    atomic-vim = {
      type = "git";
      url = "https://codeberg.org/midischwarz12/atomic-vim";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.nixos-rohr = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs self system; };

        modules = [ ./configuration.nix ];
      };
    };
}

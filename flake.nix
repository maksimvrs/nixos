# flake.nix
{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, ... }:
  let
    system = "x86_64-linux";
    variables = import ./hosts/maksim-pc/variables.nix;
  in {
    nixosConfigurations.${variables.hostname} = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit variables;
        inherit (nixpkgs) lib;
        zen-browser-packages = zen-browser.packages.${system};
      };

      modules = [
        ./hosts/maksim-pc/default.nix
        ./hosts/maksim-pc/hardware-configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inherit variables;
            zen-browser-packages = zen-browser.packages.${system};
          };
          home-manager.users.${variables.username} = import ./home/maksim.nix;
        }
      ];
    };
  };
}

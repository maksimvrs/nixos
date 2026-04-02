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
    variables = import ./hosts/thinkpad-x1/variables.nix;
    zenBrowserPackages = zen-browser.packages.${system};
  in {
    nixosConfigurations.${variables.hostname} = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit variables zenBrowserPackages;
      };

      modules = [
        ./hosts/thinkpad-x1/default.nix
        ./hosts/thinkpad-x1/hardware-configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inherit variables zenBrowserPackages;
          };
          home-manager.users.${variables.username} = import ./home/maksim.nix;
        }
      ];
    };
  };
}

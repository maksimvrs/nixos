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

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, firefox-addons, sops-nix, claude-code, ... }:
  let
    system        = "x86_64-linux";
    variables     = import ./hosts/thinkpad-x1/variables.nix;
    firefoxAddons = firefox-addons.packages.${system};
  in {
    nixosConfigurations.${variables.hostname} = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit variables;
      };

      modules = [
        { nixpkgs.overlays = [ claude-code.overlays.default ]; }

        ./hosts/thinkpad-x1/default.nix
        ./hosts/thinkpad-x1/hardware-configuration.nix

        sops-nix.nixosModules.sops

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.sharedModules = [ zen-browser.homeModules.beta ];
          home-manager.extraSpecialArgs = {
            inherit variables firefoxAddons;
          };
          home-manager.users.${variables.username} = import ./home/maksim.nix;
        }
      ];
    };
  };
}

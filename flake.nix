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

    claude-code.url = "github:sadjow/claude-code-nix";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      zen-browser,
      firefox-addons,
      claude-code,
      niri,
      noctalia,
      stylix,
      ...
    }:
    let
      system = "x86_64-linux";
      variables = import ./hosts/thinkpad-x1/variables.nix;
      firefoxAddons = firefox-addons.packages.${system};
    in
    {
      nixosConfigurations.${variables.hostname} = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit variables;
        };

        modules = [
          { nixpkgs.overlays = [ claude-code.overlays.default ]; }

          niri.nixosModules.niri

          ./hosts/thinkpad-x1/default.nix
          ./hosts/thinkpad-x1/hardware-configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              sharedModules = [
                zen-browser.homeModules.beta
                noctalia.homeModules.default
                stylix.homeModules.stylix
              ];
              extraSpecialArgs = {
                inherit variables firefoxAddons;
              };
              users.${variables.username} = import ./home/maksim.nix;
            };
          }
        ];
      };
    };
}

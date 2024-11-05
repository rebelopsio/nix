{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:
  let
    commonConfig = ./darwin-configuration.nix;
  in
  {
    nixpkgs.overlays = [
      (import ./../overlays/telegram-overlay.nix)
    ];

    darwinConfigurations = {
      squirtle = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit self;
          currentHostname = "squirtle";
        };
        modules = [ 
          commonConfig
          ./../machines/squirtle/squirtle.nix
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "stephenmorgan";
              autoMigrate = true;
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                currentHostname = "squirtle";
              };
              users.stephenmorgan = import ./home.nix;
            };
          }
        ];
      };

      charmander = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit self;
          currentHostname = "charmander";
        };
        modules = [ 
          commonConfig
          ./../machines/charmander/charmander.nix
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "smorgan";
              autoMigrate = true;
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                currentHostname = "charmander";
              };
              users.smorgan = import ./home.nix;
            };
          }
        ];
      };
    };
  };
}

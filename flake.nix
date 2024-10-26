{
  description = "marcus darwin config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-24.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    darwin,
    home-manager,
    nixvim,
    nixpkgs,
    ...
  } @ inputs: let
    mkDarwinSystem = {hostConfig}:
      darwin.lib.darwinSystem {
        inherit (hostConfig) system;
        modules = [
          hostConfig.configuration
          ./modules/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${hostConfig.username} = import ./home.nix;
            home-manager.extraSpecialArgs = {inherit inputs;};
          }
        ];
        specialArgs = {inherit inputs hostConfig;};
      };
    mkNixosSystem = {hostConfig}:
      nixpkgs.lib.nixosSystem {
        inherit (hostConfig) system;
        modules = [
          ./hosts/toddler/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${hostConfig.username} = import ./home.nix;
            home-manager.extraSpecialArgs = {inherit inputs hostConfig;};
          }
        ];

        specialArgs = {inherit inputs hostConfig;};
      };
  in {
    darwinConfigurations = {
      "marcus" = mkDarwinSystem {
        hostConfig = import ./hosts/marcus;
      };
    };
    nixosConfigurations = {
      "toddler" = mkNixosSystem {
        hostConfig = import ./hosts/toddler;
      };
    };
  };
}

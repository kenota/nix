{
  description = "marcus nix-darwin config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-24.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixvim, nixpkgs, ... }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      environment.pathsToLink = [ "/share/zsh" ];


      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
      
      users.users.kenota = {
        name = "kenota";
        home = "/Users/kenota";
      };

      homebrew = {
        enable = true;
        casks = [
          "nikitabobko/tap/aerospace"
        ];
      }; 
    };
    work = { pkgs, config, ...}: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
	        pkgs.karabiner-elements
	        pkgs.mkalias
        ];

      system.activationScripts.applications.text = let
	env = pkgs.buildEnv {
	  name = "system-applications";
	  paths = config.environment.systemPackages;
	  pathsToLink = "/Applications";
	};
      in
	pkgs.lib.mkForce ''
	# Set up applications.
	echo "setting up /Applications..." >&2
	rm -rf /Applications/Nix\ Apps
	mkdir -p /Applications/Nix\ Apps
	find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
	while read src; do
	  app_name=$(basename "$src")
	  echo "copying $src" >&2
	  ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
	done
	  '';

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      
      users.users."egor.ermakov" = {
        name = "egor.ermakov";
        home = "/Users/egor.ermakov";
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."marcus" = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [ 
        configuration
        home-manager.darwinModules.home-manager
	{
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
	  home-manager.users.kenota = import ./home.nix; 
	  home-manager.backupFileExtension = "backup";
	}

      ];
    };

    # Expose the package set, including overlays, for convenience.
    # darwinPackages = self.darwinConfigurations."marcus".pkgs;


    darwinConfigurations."EErmakov1" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ 
        work
        home-manager.darwinModules.home-manager
	{
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
	  home-manager.users."egor.ermakov" = import ./home.nix; 
	}

      ];
    };
  };
}

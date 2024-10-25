
{ config, pkgs, ...}:

{
 
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [ pkgs.vim ];

      environment.pathsToLink = [ "/share/zsh" ];


      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
    

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

    
      homebrew = {
        enable = true;
        casks = [
          "nikitabobko/tap/aerospace"
        ];
      }; 
}

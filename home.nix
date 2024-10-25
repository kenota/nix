{ config, pkgs, inputs, ... }:

{
  imports = [
    ./neovim.nix
  ];

  home.stateVersion = "24.05"; 

  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
	   	"JetBrainsMono"
      ];
    })

    clojure
    babashka
    awscli2
    jq
		tmux
		ripgrep
    rclone

  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/kenota/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      theme = "alanpeabody";
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    userEmail = "unplaced@gmail.com";
    userName = "kenota";
  };
}

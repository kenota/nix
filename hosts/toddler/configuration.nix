# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "toddler"; # Define your hostname.
  
  # Align the angelbrackets path with the pinned version from flake
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  # Set your time zone.
  time.timeZone = "Europe/London";

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver # previously vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      intel-media-sdk # QSV up to 11th gen
    ];
  };
  

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;

  users.users.kenota = {
     isNormalUser = true;
     extraGroups = [ "wheel" "jellyfin" ]; # Enable ‘sudo’ for the user.
     shell = pkgs.zsh;
     packages = with pkgs; [
       
     ];
  };


  # LIST PACKAGES INSTALLED IN SYSTEM PROFILE. TO SEARCH, RUN:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     tailscale
     jellyfin
     jellyfin-web
     jellyfin-ffmpeg
    git
  ];

  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
     enable = true;
     openFirewall = true;
  };
  
  services.tailscale = {
      enable = true;
      openFirewall = true;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  
  systemd.tmpfiles.rules = [
    "d /mnt/media 2770 jellyfin jellyfin"
  ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
      # 22
  ];
  networking.firewall.allowedUDPPorts = [
      # 41641
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
     experimental-features = nix-command flakes
    '';
  };
  
  system.stateVersion = "24.05"; # Did you read the comment?

}


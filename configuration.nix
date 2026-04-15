{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/asahi.nix
    ./modules/niri.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Binary caches
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.settings = {
    auto-optimise-store = true;
    trusted-users = [ "root" "ruben" ];
    substituters = [
      "https://niri.cachix.org"
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "niri.cachix.org-1:Wv00m07PsuocRKzfDoJ3mulS17Z6oezYhGhR+3W2964="
    ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Audio & camera
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Docker
  virtualisation.docker.enable = true;

  # 1Password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ruben" ];
  };
  environment.etc."1password/custom_allowed_browsers" = {
    text = "firefox-devedition\n";
    mode = "0755";
  };

  # Shell
  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  # User
  users.users.ruben = {
    isNormalUser = true;
    extraGroups = [ "docker" "networkmanager" "wheel" "video" "audio" "render" ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    GNOME_KEYRING_CONTROL  = "/run/user/$UID/keyring";
    SSH_AUTH_SOCK          = "/run/user/$UID/keyring/ssh";
    XDG_CURRENT_DESKTOP    = "niri";
    NIXOS_OZONE_WL         = "1";  # enables Wayland mode in slacky/Electron apps
    UV_PYTHON_DOWNLOADS    = "never";  # use nix-provided Pythons, not uv-managed ones
  };
  services.dbus.enable = true;
  services.upower.enable = true;
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  time.timeZone = "Europe/Amsterdam";
  hardware.bluetooth.enable = true;

  system.stateVersion = lib.mkForce "24.11";
}

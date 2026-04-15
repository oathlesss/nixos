{ pkgs, lib, ... }:
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

  services = {
    # Audio & camera
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    dbus.enable = true;
    upower.enable = true;
    xserver.videoDrivers = [ "displaylink" "modesetting" ];
  };

  # Docker
  virtualisation.docker.enable = true;

  programs = {
    # 1Password
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "ruben" ];
    };

    # Shell
    fish.enable = true;
    nix-ld.enable = true;
  };
  environment.etc."1password/custom_allowed_browsers" = {
    text = "firefox-devedition\n";
    mode = "0755";
  };

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
  };
  time.timeZone = "Europe/Amsterdam";
  hardware.bluetooth.enable = true;

  system.stateVersion = lib.mkForce "24.11";
}

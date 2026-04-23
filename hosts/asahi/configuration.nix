{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/asahi.nix
    ../../modules/niri.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Virtual camera: transcode FaceTime NV12 → MJPEG for Chromium compatibility
  boot.kernelModules = [
    "v4l2loopback"
    "wireguard"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=10 card_label="VirtualCam" exclusive_caps=1
  '';

  # Network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [ wireguard-tools ];

  # Binary caches
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.settings = {
    auto-optimise-store = true;
    trusted-users = [
      "root"
      "ruben"
    ];
    substituters = [
      "https://niri.cachix.org"
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "niri.cachix.org-1:Wv00m07PsuocRKzfDoJ3mulS17Z6oezYhGhR+3W2964="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
    max-jobs = "auto";
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  services = {
    # Audio & camera
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
        extraConfig = {
          # Stabilize Bluetooth headset behavior (Sony WH-1000XM5 and similar)
          "10-bluez-properties" = {
            # Replace the entire BlueZ properties object to prevent codec list merges.
            "override.monitor.bluez.properties" = {
              "bluez5.enable-hw-volume" = false;
              "bluez5.roles" = [
                "a2dp_sink"
                "a2dp_source"
                "hfp_hf"
              ];
              "bluez5.codecs" = [
                "sbc"
                "aac"
              ];
            };
          };

          # Prefer Bluetooth sink when connected and ensure profiles auto-connect
          "11-bluez-routing" = {
            "monitor.bluez.rules" = [
              {
                matches = [ { "device.name" = "~bluez_card.*"; } ];
                actions."update-props"."bluez5.auto-connect" = [ "a2dp_sink" ];
              }
              {
                matches = [ { "node.name" = "~bluez_output.*"; } ];
                actions."update-props" = {
                  "priority.driver" = 2000;
                  "priority.session" = 2000;
                };
              }
            ];
          };

          # Avoid overly loud default restore levels
          "20-volume-defaults" = {
            "wireplumber.settings" = {
              "device.restore-routes" = true;
              "node.restore-default-targets" = true;
              "device.routes.default-sink-volume" = 0.30;
            };
          };
        };
      };
    };
    dbus.enable = true;
    upower.enable = true;
    xserver.videoDrivers = [
      "displaylink"
      "modesetting"
    ];
  };

  zramSwap.enable = true;

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
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "render"
    ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;

  services.gnome.gnome-keyring.enable = true;
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-online-accounts.enable = true;
  time.timeZone = "Europe/Amsterdam";
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  system.stateVersion = "24.11";
}

{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/desktop.nix
    ./modules/services.nix
    ./modules/packages.nix
    ./modules/user.nix
  ];

  # nix
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # boot
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # system
  time.timeZone = "America/Denver";
  system.stateVersion = "25.11";

  # networking & hardware
  networking = {
    hostName = "ts-laptop09";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
  hardware = {
    bluetooth.enable = true;
    keyboard.qmk.enable = true;
  };
}

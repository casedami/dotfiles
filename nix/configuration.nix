{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

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
  hardware.bluetooth.enable = true;

  # services
  services = {
    xserver.enable = true;
    fwupd.enable = true;
    libinput.enable = true;
    hypridle.enable = true;
    keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings.main.capslock = "esc";
      };
    };
  };

  # desktop
  programs = {
    ssh.startAgent = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    hyprlock.enable = true;
    waybar.enable = true;
    firefox.enable = true;
  };
  fonts.packages = with pkgs; [ nerd-fonts.lilex ];

  # packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    nautilus
    brightnessctl
    playerctl
    bluetui
  ];

  # user
  users.users.cdm = {
    isNormalUser = true;
    home = "/home/cdm";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    packages = with pkgs; [
      # cli
      bat
      bottom
      gcc
      gh
      fzf
      macchina
      ripgrep
      tree
      tree-sitter
      vivid
      yazi
      zathura
      zoxide
      # dev
      cargo
      lua-language-server
      neovim
      nil
      nixfmt
      nushell
      python3
      stylua
      uv
      # apps
      claude-code
      ghostty
      slack
      spotify
      # hypr ecosystem
      hypridle
      hyprlauncher
      hyprpaper
      hyprpolkitagent
      hyprtoolkit
      mako
    ];
  };
}

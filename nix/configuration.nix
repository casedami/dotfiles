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
  hardware = {
    bluetooth.enable = true;
    keyboard.qmk.enable = true;
  };

  # services
  services = {
    xserver.enable = true;
    fwupd.enable = true;
    libinput.enable = true;
    hypridle.enable = true;
    power-profiles-daemon.enable = true;
    udev = {
      enable = true;
      packages = with pkgs; [
        qmk
        qmk-udev-rules
        vial
      ];
    };
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
    ssh = {
      startAgent = true;
      extraConfig = ''
        Host *
          AddKeysToAgent yes
      '';
    };
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    hyprlock.enable = true;
    waybar.enable = true;
    firefox.enable = true;
  };
  fonts.packages = with pkgs; [
    nerd-fonts.lilex
  ];

  # packages
  environment.systemPackages = with pkgs; [
    bluetui
    brightnessctl
    git
    nautilus
    playerctl
    qmk
    qmk-udev-rules
    vial
    vim
    wget
  ];

  # user
  users.users.cdm = {
    isNormalUser = true;
    hashedPassword = "$6$RAgjP7adpCx6sk3S$9TQM2YxLj1wkUesVxyBRcXjjvj8wwTkLKeIa44evY0ynk2LNojCcJRWrGGJkErV4sa.HNcDHXoUERGjYje6u7/";
    home = "/home/cdm";
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
      "plugdev"
    ];
    packages = with pkgs; [
      # cli
      bat
      bottom
      difftastic
      gcc
      fzf
      gh
      gowall
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
      stylua
      typst
      uv
      # apps
      claude-code
      ghostty
      slack
      spotify
      # hypr ecosystem
      hypridle
      hyprshot
      hyprpaper
      hyprpolkitagent
      hyprtoolkit
      rofi
      mako
    ];
  };
}

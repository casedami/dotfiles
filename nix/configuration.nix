{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Denver";
  networking.hostName = "ts-laptop09";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  hardware.bluetooth.enable = true;
  services.xserver.enable = true;
  services.fwupd.enable = true;
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        capslock = "esc";
      };
    };
  };
  programs.ssh.startAgent = true;

  services.libinput.enable = true;

  users.users.cdm = {
    isNormalUser = true;
    home = "/home/cdm";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    packages = with pkgs; [
      tree
      neovim
      nushell
      macchina
      stylua
      cargo
      uv
      python3
      nil
      nixfmt
      ghostty
      yazi
      slack
      zathura
      spotify
      bat
      bottom
      gh
      gcc
      tree-sitter
      zoxide
      fzf
      ripgrep
      vivid
      claude-code
      hyprpaper
      hypridle
      hyprlauncher
      hyprtoolkit
      hyprpolkitagent
      mako
    ];
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
  programs.waybar.enable = true;
  programs.firefox.enable = true;
  fonts.packages = with pkgs; [ nerd-fonts.lilex ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    nautilus
    brightnessctl
    playerctl
    bluetui
  ];

  system.stateVersion = "25.11";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

}

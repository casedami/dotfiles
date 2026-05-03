{
  config,
  lib,
  pkgs,
  ...
}:
let
  unstable = import <nixpkgs-unstable> { config.allowUnfree = true; };
in
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "ts-laptop09";

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  time.timeZone = "America/Denver";

  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        capslock = "esc";
      };
    };
  };

  services.libinput.enable = true;

  users.users.cdm = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    packages = with pkgs; [
      tree
      unstable.neovim
      unstable.nushell
      unstable.cargo
      unstable.uv
      unstable.python3
      nil
      nixfmt
      ghostty
      yazi
      bat
      gh
      gcc
      tree-sitter
      zoxide
      fzf
      ripgrep
      unstable.vivid
      claude-code
    ];
  };

  programs.firefox.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.lilex
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  system.stateVersion = "25.11";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

}

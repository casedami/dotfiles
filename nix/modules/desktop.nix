{
  config,
  lib,
  pkgs,
  ...
}:
{
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
    nix-ld.enable = true;
  };
  fonts.packages = with pkgs; [
    nerd-fonts.lilex
  ];
}

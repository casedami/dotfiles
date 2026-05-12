{ config, lib, pkgs, ... }:
{
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
}

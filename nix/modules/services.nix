{
  config,
  lib,
  pkgs,
  ...
}:
{
  services = {
    xserver.enable = true;
    fwupd.enable = true;
    libinput.enable = true;
    hypridle.enable = true;
    playerctld.enable = true;
    power-profiles-daemon.enable = true;
    tailscale.enable = true;
    udev = {
      enable = true;
      packages = with pkgs; [
        qmk
        qmk-udev-rules
        vial
      ];
    };
  };
}

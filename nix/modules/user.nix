{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.cdm = {
    isNormalUser = true;
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
      rustup
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
      wl-screenrec
      slurp
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

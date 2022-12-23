# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, pkgs, ... }: {
  imports = [
    ./global
    ./features/desktop/hyprland
    ./features/desktop/wireless
  ];

  wallpaper = (import ./wallpapers).aenami-lunar;
  colorscheme = inputs.nix-colors.colorschemes.paraiso;

  monitors = [{
    name = "eDP-1";
    width = 2560;
    height = 1440;
    workspace = "1";
    scale = 2;
  }];
}

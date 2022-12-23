# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, outputs, ... }: 
let
  inherit (inputs.nix-colors) colorSchemes;
  inherit (inputs.nix-colors.lib-conrtib { inherit pkgs; }) colorschemeFromPicture nixWallpaperFromScheme;
in

{
  imports = [
    inputs.nix-colors.homeManagerModule
    ../features/cli
    ../features/nvim
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake"];
      warn-dirty = false;
    };
  };

  systemd.user.startServices = "sd-switch";

  # Enable home-manager and git
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = "speng";
    homeDirectory = "/home/speng";
    stateVersion = "22.11";
  };

  colorscheme = lib.mkDefault colorSchemes.dracula;
  wallpaper =
    let
      largest = f: xs: builtins.head (builtins.sort (a: b: a > b) (map f xs));
      largestWidth = largest (x: x.width) config.monitors;
      largestHeight = largest (x: x.height) config.monitors;
    in
    lib.mkDefault (nixWallpaperFromScheme
      {
        scheme = config.colorscheme;
        width = largestWidth;
        height = largestHeight;
        logoScale = 4;
      });
  home.file.".colorscheme".text = config.colorscheme.slug;
}

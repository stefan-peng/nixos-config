{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./bat.nix
    ./fish.nix
    ./git.nix
    ./gpg.nix
    ./nix-index.nix
    ./pfetch.nix
    ./ranger.nix
    ./screen.nix
    ./shellcolor.nix
    ./ssh.nix
    ./starship.nix
    ./xpo.nix
  ];
  home.packages = with pkgs; [
    pciutils

    comma # Install and run programs by sticking a , before them
    distrobox # Nice escape hatch, integrates docker images with my environment

    bc # Calculator
    bottom # System viewer
    ncdu # TUI disk usage
    exa # Better ls
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    jq # JSON pretty printer and manipulator
    trekscii # Cute startrek cli printer

    rnix-lsp # Nix LSP
    nixfmt # Nix formatter

    onedrive
  ];
}

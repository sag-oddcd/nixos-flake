{ config, pkgs, ... }:

{
  # System packages
  environment.systemPackages = with pkgs; [
    # Essential system tools
    vim
    wget
    curl
    git

    # Nix tools
    nixpkgs-fmt
    alejandra
    statix
    deadnix

    # Hardware tools
    pciutils
    usbutils

    # Wayland essentials
    wl-clipboard

    # NVIDIA tools
    nvtopPackages.nvidia
  ];
}

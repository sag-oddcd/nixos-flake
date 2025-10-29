{pkgs, ...}: {
  # System packages
  environment.systemPackages = with pkgs; [
    # Essential system tools
    vim
    wget
    curl
    git
    htop

    # Nix tools
    nixpkgs-fmt
    alejandra
    statix
    deadnix

    # Hardware tools
    pciutils
    usbutils

    # Disk management
    parted
    gptfdisk
    cryptsetup

    # Btrfs tools
    btrfs-progs
    compsize # Check compression ratios

    # LVM tools
    lvm2

    # Secure Boot tools
    sbctl # For managing Secure Boot keys

    # Wayland essentials
    wl-clipboard

    # NVIDIA tools
    nvtopPackages.nvidia
  ];
}

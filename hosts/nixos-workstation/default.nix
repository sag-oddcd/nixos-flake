{ config, pkgs, inputs, ... }:

{
  # System state version
  system.stateVersion = "24.11";

  # Import all system modules
  imports = [
    # Hardware configuration (generated during install)
    ./hardware-configuration.nix

    # System modules
    ../../modules/system/boot.nix
    ../../modules/system/networking.nix
    ../../modules/system/localization.nix
    ../../modules/system/nvidia.nix
    ../../modules/system/audio.nix
    ../../modules/system/security.nix
    ../../modules/system/virtualization.nix
    ../../modules/system/nix.nix
    ../../modules/system/packages.nix

    # Hardware modules - PC-specific
    ../../modules/hardware/cpu-amd.nix      # AMD CPU optimizations
    ../../modules/hardware/nvme.nix          # Samsung NVMe optimizations
    ../../modules/hardware/gigabyte.nix      # Gigabyte motherboard
  ];
}

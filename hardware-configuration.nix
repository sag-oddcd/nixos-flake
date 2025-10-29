# Samsung 970 EVO 500GB - LVM on LUKS with Btrfs
# Generated for: Option 4 (LVM + Btrfs hybrid)
# Hibernate: Enabled (40GB swap)
# Unlock: Password only

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    # Kernel modules for NVMe and encryption
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ]; # LVM support

      # LUKS configuration
      luks.devices = {
        cryptroot = {
          device = "/dev/disk/by-uuid/REPLACE-WITH-NVME0N1P3-UUID";
          preLVM = true; # Unlock before LVM activation
          allowDiscards = true; # Enable TRIM for SSD
          bypassWorkqueues = true; # Performance optimization for NVMe
        };
      };
    };

    kernelModules = [ "kvm-intel" ]; # Change to "kvm-amd" if AMD CPU
    extraModulePackages = [ ];

    # Resume from hibernate
    resumeDevice = "/dev/vg0/swap-lv";

    # Kernel parameters
    kernelParams = [
      "resume=/dev/vg0/swap-lv"
      "quiet" # Less verbose boot
      "splash" # Boot splash screen
    ];
  };

  # Filesystems
  fileSystems = {
    "/" = {
      device = "/dev/vg0/btrfs-lv";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "compress=zstd:1" # Compression for space savings
        "noatime" # Performance optimization
        "space_cache=v2" # Improved free space tracking
      ];
    };

    "/home" = {
      device = "/dev/vg0/btrfs-lv";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd:1"
        "noatime"
        "space_cache=v2"
      ];
    };

    "/data" = {
      device = "/dev/vg0/btrfs-lv";
      fsType = "btrfs";
      options = [
        "subvol=@data"
        "compress=zstd:1"
        "noatime"
        "space_cache=v2"
      ];
    };

    "/.snapshots" = {
      device = "/dev/vg0/btrfs-lv";
      fsType = "btrfs";
      options = [
        "subvol=@snapshots"
        "compress=zstd:1"
        "noatime"
        "space_cache=v2"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/REPLACE-WITH-NVME0N1P2-UUID";
      fsType = "ext4";
      options = [ "noatime" ];
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/REPLACE-WITH-NVME0N1P1-UUID";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ]; # Secure permissions
    };
  };

  # Swap
  swapDevices = [
    { device = "/dev/vg0/swap-lv"; }
  ];

  # CPU microcode updates
  hardware.cpu.intel.updateMicrocode = true; # Change to amd if AMD CPU

  # Networking
  networking.useDHCP = lib.mkDefault true;

  # Power management
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # NixOS state version (DO NOT CHANGE after installation)
  system.stateVersion = "24.11"; # Or "unstable" based on your choice
}

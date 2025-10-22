{ config, pkgs, ... }:

{
  boot = {
    # Bootloader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Kernel - latest for best hardware support
    kernelPackages = pkgs.linuxPackages_latest;
  };
}

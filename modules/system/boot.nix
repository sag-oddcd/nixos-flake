{
  pkgs,
  lib,
  ...
}: {
  boot = {
    # Bootloader - Lanzaboote for Secure Boot support
    loader = {
      systemd-boot.enable = lib.mkForce false; # Disabled in favor of lanzaboote
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };

    # Lanzaboote (Secure Boot support)
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot"; # Secure Boot keys location
    };

    # Kernel - latest for best hardware support
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Hibernate support
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1h
  '';
}

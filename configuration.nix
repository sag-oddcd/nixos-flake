# NixOS Configuration with Secure Boot (Lanzaboote)
# System: Samsung 970 EVO 500GB
# Security: LUKS encryption, Secure Boot, password-only unlock

{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader - Lanzaboote for Secure Boot
  boot.loader = {
    systemd-boot.enable = lib.mkForce false; # Disabled in favor of lanzaboote

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  # Lanzaboote (Secure Boot support)
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot"; # Secure Boot keys location
  };

  # System configuration
  networking.hostName = "nixos"; # Change to your preferred hostname

  # Time zone
  time.timeZone = "America/New_York"; # Change to your timezone

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Console configuration
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us"; # Change to your keyboard layout
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Users
  users.users.yourusername = { # CHANGE THIS
    isNormalUser = true;
    description = "Your Name"; # CHANGE THIS
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    initialPassword = "changeme"; # CHANGE THIS immediately after first boot
  };

  # Enable sudo
  security.sudo.enable = true;

  # Essential packages
  environment.systemPackages = with pkgs; [
    # System tools
    vim
    wget
    curl
    git
    htop

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
  ];

  # Enable OpenSSH (optional, comment out if not needed)
  # services.openssh = {
  #   enable = true;
  #   settings.PermitRootLogin = "no";
  #   settings.PasswordAuthentication = false;
  # };

  # Hibernate support
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1h
  '';

  # Btrfs auto-scrub (data integrity check)
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  # Automatic snapshots before nixos-rebuild (optional)
  # You can add snapper or btrbk here later

  # TRIM support for SSD
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Firmware updates
  services.fwupd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

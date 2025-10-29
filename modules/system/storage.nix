{...}: {
  # Btrfs auto-scrub (data integrity check)
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"];
  };

  # TRIM support for SSD (weekly maintenance)
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Firmware updates
  services.fwupd.enable = true;
}

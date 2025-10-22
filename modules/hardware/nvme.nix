{ config, pkgs, ... }:

{
  boot = {
    kernelParams = [
      # NVMe optimizations - disable power saving for performance
      "nvme_core.default_ps_max_latency_us=0"
    ];

    # Load NVMe modules early
    initrd.availableKernelModules = [ "nvme" ];
  };

  # Samsung NVMe-specific optimizations
  services.fstrim = {
    enable = true;  # Weekly TRIM for SSD health
    interval = "weekly";
  };

  # NVMe monitoring tools
  environment.systemPackages = with pkgs; [
    nvme-cli     # NVMe management utility
    smartmontools  # SMART monitoring for NVMe
  ];
}

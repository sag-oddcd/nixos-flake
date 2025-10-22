{ config, lib, pkgs, ... }:

{
  # AMD CPU optimizations
  boot = {
    kernelModules = [ "kvm-amd" ];  # KVM virtualization support
  };

  # CPU microcode updates
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # AMD-specific packages
  environment.systemPackages = with pkgs; [
    amdctl        # AMD K7/K8 processor control
    zenpower      # AMD Zen CPU monitoring (if supported)
  ];

  # Performance governor for AMD
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # AMD P-State driver (for Zen 2+ CPUs)
  boot.kernelParams = [
    "amd_pstate=active"  # Enable AMD P-State EPP driver (Zen 2+)
  ];
}

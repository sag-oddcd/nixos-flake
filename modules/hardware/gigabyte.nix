{pkgs, ...}: {
  # Gigabyte motherboard optimizations

  # Sensors for Gigabyte motherboards
  environment.systemPackages = with pkgs; [
    lm_sensors # Hardware monitoring (motherboard temps, fans)
    dmidecode # BIOS/SMBIOS information
  ];

  # Enable sensor detection
  hardware.sensor.iio.enable = true;

  # ACPI support (important for Gigabyte BIOS)
  boot.kernelParams = [
    "acpi_osi=Linux" # Better ACPI compatibility
  ];
}

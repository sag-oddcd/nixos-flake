{config, ...}: {
  # NVIDIA Hardware
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true; # For 32-bit games/apps
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false; # Can cause issues
      powerManagement.finegrained = false;
      open = false; # Use proprietary driver
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  # X11/Wayland
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];

    # Keyboard layout
    xkb = {
      layout = "br";
      variant = "abnt2";
    };
  };

  # Wayland NVIDIA environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Electron apps on Wayland
    WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor on NVIDIA
  };
}

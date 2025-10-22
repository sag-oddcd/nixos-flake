{ config, pkgs, inputs, ... }:

{
  # System Configuration
  system.stateVersion = "24.11";

  # Bootloader
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Kernel - latest for best hardware support
    kernelPackages = pkgs.linuxPackages_latest;

    # NVMe optimizations
    kernelParams = [
      "nvme_core.default_ps_max_latency_us=0"  # Disable power saving for NVMe
    ];
  };

  # Networking
  networking = {
    hostName = "nixos-workstation";
    networkmanager.enable = true;

    # Firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  # Localization
  time.timeZone = "America/Sao_Paulo";
  i18n = {
    defaultLocale = "pt_BR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  # Console
  console = {
    keyMap = "br-abnt2";
    font = "Lat2-Terminus16";
  };

  # NVIDIA Drivers (Proprietary)
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;  # For 32-bit games/apps
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;  # Can cause issues
      powerManagement.finegrained = false;
      open = false;  # Use proprietary driver
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  # X11/Wayland
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    # Keyboard layout
    xkb = {
      layout = "br";
      variant = "abnt2";
    };
  };

  # Wayland support
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # Electron apps on Wayland
    WLR_NO_HARDWARE_CURSORS = "1";  # Fix cursor on NVIDIA
  };

  # Display Manager - greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd fish";
        user = "greeter";
      };
    };
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Users
  users.users.jf = {
    isNormalUser = true;
    description = "jf";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" ];
    shell = pkgs.fish;
  };

  # Fish shell
  programs.fish.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Essential system tools
    vim
    wget
    curl
    git

    # Nix tools
    nixpkgs-fmt
    alejandra
    statix
    deadnix

    # Hardware tools
    pciutils
    usbutils

    # Wayland essentials
    wl-clipboard

    # NVIDIA tools
    nvtopPackages.nvidia
  ];

  # Enable docker
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };

  # Nix settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "jf" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Allow unfree packages (NVIDIA drivers, etc.)
  nixpkgs.config.allowUnfree = true;

  # Security
  security = {
    sudo-rs.enable = true;
    polkit.enable = true;
    pam.services.greetd.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;
}

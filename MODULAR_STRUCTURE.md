# Modular NixOS Flake Structure

This flake uses a modular architecture for better organization, reusability, and maintainability.

## Directory Structure

```
.
├── flake.nix                       # Main entry point
├── flake.lock                      # Locked dependencies (generated)
│
├── hosts/                          # Per-host configurations
│   └── nixos-workstation/
│       ├── default.nix            # Imports all modules for this host
│       └── hardware-configuration.nix  # Generated during install
│
├── modules/                        # Reusable system modules
│   ├── system/                    # System-level configuration
│   │   ├── boot.nix              # Bootloader & kernel
│   │   ├── networking.nix        # Network configuration
│   │   ├── localization.nix      # Timezone, locale, keyboard
│   │   ├── nvidia.nix            # NVIDIA drivers & Wayland
│   │   ├── audio.nix             # PipeWire & Bluetooth
│   │   ├── security.nix          # Users, sudo, PAM, greetd
│   │   ├── virtualization.nix    # Docker configuration
│   │   ├── nix.nix               # Nix settings & garbage collection
│   │   └── packages.nix          # System packages
│   │
│   └── hardware/                  # Hardware-specific tweaks
│       └── nvme.nix              # NVMe optimizations
│
├── home/                          # Home Manager configurations
│   └── jf/                       # Per-user configuration
│       ├── default.nix           # User entry point
│       ├── shell.nix             # Fish, starship, zoxide, atuin
│       ├── git.nix               # Git, jujutsu, gitui
│       ├── cli-tools.nix         # Rust-native CLI tools
│       ├── development.nix       # Neovim, LSPs, dev tools
│       └── desktop.nix           # GUI apps, browsers, Wayland
│
└── overlays/                      # Package overlays (future use)
    └── (empty for now)
```

## Module Organization Principles

### System Modules (`modules/system/`)

**Purpose:** System-wide configuration that affects all users

**Categorization:**
- **boot.nix** - Everything related to booting the system
- **networking.nix** - Network, firewall, hostname
- **localization.nix** - Language, timezone, keyboard layout
- **nvidia.nix** - GPU drivers and display server
- **audio.nix** - Audio and Bluetooth
- **security.nix** - Users, authentication, display manager
- **virtualization.nix** - Docker, VMs, containers
- **nix.nix** - Nix daemon configuration
- **packages.nix** - Essential system packages

**Import Location:** `hosts/<hostname>/default.nix`

### Hardware Modules (`modules/hardware/`)

**Purpose:** Hardware-specific optimizations and tweaks

**Examples:**
- **nvme.nix** - NVMe SSD optimizations
- Future: gpu-specific configs, CPU microcode, etc.

**Import Location:** `hosts/<hostname>/default.nix`

### Home Modules (`home/<username>/`)

**Purpose:** User-specific configuration (dotfiles, packages, programs)

**Categorization:**
- **shell.nix** - Shell environment (Fish, prompt, navigation)
- **git.nix** - Version control tools
- **cli-tools.nix** - Command-line utilities
- **development.nix** - Programming tools and IDEs
- **desktop.nix** - GUI applications

**Import Location:** `home/<username>/default.nix`

## Benefits of Modular Structure

### 1. **Reusability**
```nix
# Easy to reuse modules across multiple hosts
imports = [
  ../../modules/system/boot.nix
  ../../modules/system/nvidia.nix  # Only import what you need
];
```

### 2. **Maintainability**
- Each module focuses on ONE concern
- Easy to find and edit specific configurations
- Changes are isolated and predictable

### 3. **Testing**
```bash
# Test individual modules
nix eval .#nixosConfigurations.nixos-workstation.config.boot.loader

# Verify specific module loads correctly
nix-instantiate --eval -E '(import ./modules/system/nvidia.nix { })'
```

### 4. **Sharing**
- Share individual modules with others
- Contribute modules to community
- Import modules from other flakes

### 5. **Multi-Host Support**
```
hosts/
├── nixos-workstation/    # Desktop PC
├── nixos-laptop/         # Laptop (different hardware)
└── nixos-server/         # Server (no GUI)
```

Each host imports only the modules it needs.

## Adding New Modules

### System Module

1. Create file in `modules/system/`:
```nix
# modules/system/printing.nix
{ config, pkgs, ... }:
{
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];
}
```

2. Import in host:
```nix
# hosts/nixos-workstation/default.nix
imports = [
  ../../modules/system/printing.nix
];
```

### Home Module

1. Create file in `home/jf/`:
```nix
# home/jf/gaming.nix
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    steam
    lutris
  ];
}
```

2. Import in user config:
```nix
# home/jf/default.nix
imports = [
  ./gaming.nix
];
```

## Adding New Hosts

```bash
# Create new host directory
mkdir -p hosts/nixos-laptop

# Create host configuration
cat > hosts/nixos-laptop/default.nix <<EOF
{ config, pkgs, inputs, ... }:
{
  system.stateVersion = "24.11";

  imports = [
    ./hardware-configuration.nix
    ../../modules/system/boot.nix
    ../../modules/system/networking.nix
    # Import only needed modules...
  ];

  # Laptop-specific settings
  networking.hostName = "nixos-laptop";
}
EOF

# Add to flake.nix
nixosConfigurations.nixos-laptop = nixpkgs.lib.nixosSystem {
  # ...
  modules = [ ./hosts/nixos-laptop ];
};
```

## Module Dependencies

Modules can depend on each other implicitly through NixOS options:

```nix
# modules/system/nvidia.nix sets:
services.xserver.videoDrivers = [ "nvidia" ];

# modules/system/security.nix can use:
services.greetd.settings.default_session.command =
  "${pkgs.greetd.greetd}/bin/agreety --cmd ${config.users.users.jf.shell}";
```

NixOS merges all module configurations automatically.

## Migration from Monolithic

**Before (Monolithic):**
```
flake.nix
configuration.nix  (500+ lines)
home.nix          (300+ lines)
```

**After (Modular):**
```
flake.nix         (clean entry point)
hosts/*/default.nix  (just imports)
modules/**/*.nix     (focused modules, 50-100 lines each)
home/**/*.nix        (focused modules, 50-100 lines each)
```

## Best Practices

1. **One Concern Per Module**
   - ✅ `nvidia.nix` handles GPU
   - ❌ `nvidia.nix` handles GPU + audio + networking

2. **Keep Modules Focused**
   - Target: 50-150 lines per module
   - If larger, consider splitting

3. **Use Descriptive Names**
   - ✅ `development.nix` (clear)
   - ❌ `stuff.nix` (vague)

4. **Document Module Purpose**
   ```nix
   # modules/system/audio.nix
   # Audio configuration using PipeWire
   # Includes: ALSA, PulseAudio, JACK, Bluetooth
   { config, ... }:
   {
     # ...
   };
   ```

5. **Group Related Options**
   ```nix
   # Keep related settings together
   services.pipewire = {
     enable = true;
     alsa.enable = true;
     pulse.enable = true;
   };
   ```

## Validation

After modularization, validate structure:

```bash
# Check flake structure
nix flake show

# Validate imports resolve
nix eval .#nixosConfigurations.nixos-workstation.config.system.stateVersion

# Dry-run build
nix build .#nixosConfigurations.nixos-workstation.config.system.build.toplevel --dry-run

# Full evaluation check
nix flake check
```

## See Also

- [NixOS Module System](https://nixos.wiki/wiki/NixOS_modules)
- [Home Manager Modules](https://nix-community.github.io/home-manager/index.html#sec-writing-modules)
- [Flake Parts](https://flake.parts/) - Advanced modular flake framework

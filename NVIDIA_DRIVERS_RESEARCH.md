# NVIDIA Drivers for NixOS - Comprehensive Research
## RTX 3080 Ti | Data Science/CUDA/GPU Development Focus
**Research Date:** 2025-10-23

---

## 1. FOSS Status and Licensing

### Current Status (2024-2025)

**Proprietary Driver (Default):**
- ❌ **NOT FOSS** - Traditional NVIDIA driver is proprietary/closed-source
- License: NVIDIA Proprietary License (unfree software)
- Components: Kernel modules + userspace libraries (both closed-source)
- Status: Available in NixOS via `nixpkgs.config.allowUnfree = true`

**Open-Source Kernel Modules (Available since May 2022):**
- ⚠️ **PARTIALLY OPEN** - Kernel modules are open-source, userspace is still proprietary
- Released: May 2, 2022 (GitHub: NVIDIA/open-gpu-kernel-modules)
- Current version: 580.95.05 (as of late 2024/early 2025)
- License: GPL v2 + MIT (kernel modules only)
- **Important:** Userspace components (libraries, CUDA runtime, etc.) remain proprietary
- **NixOS Default:** Since driver version 560+, open modules are preferred when available

### NixOS Configuration

**Proprietary Modules (Legacy, pre-560):**
```nix
hardware.nvidia.open = false;  # Force proprietary kernel modules
```

**Open-Source Modules (Recommended, 560+):**
```nix
hardware.nvidia.open = true;   # Use open kernel modules (default for 560+)
# OR
hardware.nvidia.open = null;   # Auto-select (defaults to open on 560+)
```

**Key Points:**
- **RTX 3080 Ti (Ampere architecture) IS SUPPORTED** by open modules
- Open modules require Turing (RTX 20-series) or newer
- Community can contribute via GitHub pull requests
- NVIDIA processes contributions through internal codebase before release
- **Trade-off:** Open kernel + proprietary userspace = hybrid approach

---

## 2. Driver Variants: Studio vs Game Ready

### Official Definitions

**Game Ready Drivers:**
- **Target Audience:** Gamers
- **Optimization:** Day-1 game releases, gaming performance
- **Release Cadence:** Frequent updates (2-4 weeks)
- **Focus:** New game support, performance tuning for popular titles
- **Stability:** Newer, potentially less tested features

**Studio Drivers:**
- **Target Audience:** Content creators, professional applications
- **Optimization:** Creative software (Adobe, Autodesk, Blender, DaVinci Resolve)
- **Release Cadence:** Less frequent (4-8 weeks), more rigorous testing
- **Focus:** Application stability, professional workflow reliability
- **Stability:** More thoroughly tested, longer QA cycle

### **RECOMMENDATION FOR DATA SCIENCE/CUDA/GPU DEVELOPMENT:**

**🏆 Use GAME READY DRIVERS (on Linux/NixOS)**

**Rationale:**

1. **Linux Distribution Model:**
   - NVIDIA does NOT distribute separate "Studio" vs "Game Ready" drivers for Linux
   - Only Windows has this distinction
   - Linux receives unified driver releases (same as "Game Ready" version numbers)
   - NixOS packages use these unified Linux drivers

2. **CUDA Compatibility:**
   - CUDA Toolkit works with both driver types
   - What matters: **Driver version ≥ minimum CUDA version requirement**
   - Example: CUDA 12.x requires driver ≥ 525.60.13
   - Game Ready drivers receive CUDA updates faster

3. **Data Science Workloads:**
   - PyTorch, TensorFlow, JAX use CUDA libraries (not driver-dependent)
   - Compute performance is identical between driver types
   - Newer drivers = better compute optimizations

4. **Professional Compute:**
   - NVIDIA Data Center drivers exist separately (for A100, H100, etc.)
   - RTX 3080 Ti = GeForce line → uses standard drivers
   - No "Studio" benefit for non-creative GPU workloads

**Summary Table:**

| Use Case | Windows | Linux/NixOS |
|----------|---------|-------------|
| Gaming | Game Ready | Unified Driver |
| Creative Apps (Adobe, Blender) | Studio | Unified Driver |
| Data Science / ML | Game Ready | Unified Driver |
| CUDA Development | Game Ready | Unified Driver |
| GPU Compute | Game Ready | Unified Driver |

**NixOS Implementation:**
```nix
# Use latest stable driver (equivalent to "Game Ready" on Windows)
hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

# OR use beta/production branches for cutting-edge features
hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
# hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
```

**Available NixOS Driver Branches:**
- `stable` - Latest stable release (recommended)
- `beta` - Bleeding-edge features (may be unstable)
- `production` - Long-term support branch
- `legacy_470` - For older GPUs
- `legacy_390` - For very old GPUs
- `dc` - Data Center drivers (Tesla/A100/H100 only)

---

## 3. NVIDIA Open-Source Initiatives

### Timeline and Status

**May 2, 2022: Open GPU Kernel Modules Released**
- Repository: https://github.com/NVIDIA/open-gpu-kernel-modules
- License: GPL v2 + MIT
- **What's Open:**
  - Linux kernel modules (GPU initialization, memory management, power management)
  - GSP (GPU System Processor) firmware interface
  - Hardware abstraction layer
- **What's Still Closed:**
  - Userspace libraries (libcuda.so, libcudart.so, libnvidia-ml.so)
  - CUDA runtime
  - OpenGL/Vulkan drivers
  - Video encode/decode libraries

**Community Contribution Status:**
- ✅ **Pull requests accepted** via GitHub
- ⚠️ **Snapshot-based model:** Changes processed through NVIDIA's internal codebase
- ⚠️ Individual commits may not appear as separate GitHub commits
- ✅ Active maintenance (version 580.95.05 as of 2024/2025)

**What Changed:**
- Before 2022: Fully proprietary, no source available
- After 2022: Kernel modules open, community can audit and contribute
- Future direction: NVIDIA prefers open modules over proprietary (per NixOS docs)

**Supported GPUs (Open Modules):**
- ✅ **RTX 3080 Ti (Ampere) - FULLY SUPPORTED**
- ✅ Turing (RTX 20-series, GTX 16-series)
- ✅ Ampere (RTX 30-series)
- ✅ Ada Lovelace (RTX 40-series)
- ✅ Hopper (H100, data center)
- ❌ Maxwell, Pascal (GTX 10-series) - Must use proprietary modules

**NixOS Integration:**
- Version 560+: Open modules are default (`hardware.nvidia.open = null`)
- Version <560: Proprietary modules are default
- Users can force either variant via `hardware.nvidia.open = true/false`

---

## 4. Compatibility Matrix (2024-2025)

| Feature | Status | Notes |
|---------|--------|-------|
| **HDR (Wayland)** | ✅ **Supported** | Driver 555+ with compatible compositors (KDE Plasma 6, Hyprland) |
| **HDR (X11)** | ⚠️ **Limited** | Depth-30 displays supported, but not full HDR like Wayland |
| **Wayland (General)** | ✅ **Supported** | GBM backend available, explicit sync added in driver 555 |
| **Wayland (Explicit Sync)** | ✅ **YES (555+)** | **Critical for tear-free Wayland** - Driver 555+ (June 2024) |
| **Wayland (GBM)** | ✅ **Supported** | Replaces EGLStreams, required for modern compositors |
| **Wayland (Hyprland)** | ✅ **Works** | Requires driver 555+, enable modesetting |
| **Wayland (KDE Plasma 6)** | ✅ **Works** | Best Wayland experience, HDR support |
| **Wayland (Sway)** | ✅ **Works** | Requires driver 555+ with explicit sync |
| **Wayland (GNOME)** | ✅ **Works** | Improved in recent releases |
| **NixOS Compatibility** | ✅ **Excellent** | First-class support, multiple driver versions available |
| **CUDA** | ✅ **Full Support** | All CUDA versions (11.x, 12.x) work |
| **Machine Learning** | ✅ **Excellent** | PyTorch, TensorFlow, JAX fully supported |
| **Vulkan** | ✅ **Full Support** | Latest Vulkan API versions |
| **OpenGL** | ✅ **Full Support** | OpenGL 4.6 |
| **Ray Tracing** | ✅ **Full Support** | RTX features, OptiX |
| **Video Encode/Decode** | ✅ **Full Support** | NVENC/NVDEC (H.264, H.265, AV1) |
| **Multi-GPU** | ✅ **Supported** | SLI deprecated, but multi-GPU compute works |
| **Dynamic Power Management** | ✅ **Supported** | Runtime PM for laptops, dynamic boost |

### Key Milestones (Recent History)

**Driver 555 (June 2024):**
- ✅ **Explicit sync for Wayland** - Eliminates tearing/flickering
- ✅ GBM backend becomes standard
- ✅ Massively improved Wayland experience

**Driver 560 (September 2024):**
- ✅ Open kernel modules become default
- ✅ Further Wayland improvements
- ✅ Enhanced HDR support

**Driver 570/575/580 (Late 2024/Early 2025):**
- ✅ Continued Wayland refinement
- ✅ Performance optimizations
- ✅ Bug fixes for compositor compatibility

### NixOS-Specific Considerations

**Configuration Requirements:**

```nix
# Minimal NVIDIA setup (NixOS)
{ config, pkgs, ... }:

{
  # Enable unfree packages (NVIDIA drivers are proprietary)
  nixpkgs.config.allowUnfree = true;

  # Load nvidia driver
  services.xserver.videoDrivers = [ "nvidia" ];

  # NVIDIA hardware settings
  hardware.nvidia = {
    # Use open-source kernel modules (driver 560+, recommended for RTX 3080 Ti)
    open = true;

    # Enable modesetting (REQUIRED for Wayland)
    modesetting.enable = true;

    # Power management (optional, useful for multi-GPU or laptops)
    powerManagement.enable = false;  # Set true for laptops

    # NVIDIA settings GUI
    nvidiaSettings = true;

    # Driver package (stable = latest production release)
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Optional: CUDA support for data science
  environment.systemPackages = with pkgs; [
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
  ];
}
```

**For Wayland:**
```nix
hardware.nvidia.modesetting.enable = true;  # MANDATORY for Wayland

# Add environment variables for Wayland compositors
environment.sessionVariables = {
  # GBM backend (modern approach)
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";

  # For some compositors (like Hyprland)
  LIBVA_DRIVER_NAME = "nvidia";
  WLR_NO_HARDWARE_CURSORS = "1";  # May be needed for some compositors
};
```

**Known Issues (NixOS-specific):**
1. **Hibernate/Suspend:** May require `hardware.nvidia.powerManagement.enable = true`
2. **Multi-monitor:** Works best with Wayland compositors (KDE Plasma 6, Hyprland)
3. **Older kernels:** Driver compatibility - use latest stable kernel
4. **PRIME (Laptops):** Desktop RTX 3080 Ti doesn't need PRIME configuration

---

## 5. NixOS Flake Configuration Recommendations

### Flake Structure (Modular Approach)

**File: `flake.nix`**
```nix
{
  description = "NixOS PC Configuration - RTX 3080 Ti Data Science Workstation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations.nixos-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Core system configuration
        ./hardware-configuration.nix
        ./configuration.nix

        # Modular NVIDIA configuration
        ./nvidia.nix

        # Home Manager integration
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.yourusername = import ./home.nix;
        }
      ];
    };
  };
}
```

**File: `nvidia.nix` (Modular NVIDIA Config)**
```nix
{ config, pkgs, ... }:

{
  # Enable unfree packages for NVIDIA drivers
  nixpkgs.config.allowUnfree = true;

  # Load NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

  # NVIDIA hardware configuration
  hardware.nvidia = {
    # Use open-source kernel modules (RTX 3080 Ti = Ampere, fully supported)
    # Driver 560+ defaults to open modules, this makes it explicit
    open = true;

    # Enable kernel modesetting (CRITICAL for Wayland)
    modesetting.enable = true;

    # Power management (false for desktop, true for laptops)
    powerManagement = {
      enable = false;
      finegrained = false;  # Optimus laptops only
    };

    # NVIDIA Settings GUI
    nvidiaSettings = true;

    # Driver package - use stable for production, beta for cutting-edge
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # Alternatives:
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    # package = config.boot.kernelPackages.nvidiaPackages.production;

    # Prime settings (NOT NEEDED for desktop RTX 3080 Ti)
    # Only for laptops with hybrid graphics
    # prime = {
    #   sync.enable = true;
    #   nvidiaBusId = "PCI:1:0:0";
    #   intelBusId = "PCI:0:2:0";
    # };
  };

  # Environment variables for Wayland (if using Wayland compositor)
  environment.sessionVariables = {
    # GBM backend for Wayland
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Wayland-specific (for compositors like Hyprland)
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";

    # XDG Desktop Portal (Wayland screen sharing)
    XDG_SESSION_TYPE = "wayland";
  };

  # CUDA and data science packages
  environment.systemPackages = with pkgs; [
    # NVIDIA utilities
    nvidia-system-monitor-qt  # GPU monitoring GUI
    nvtopPackages.full        # GPU process monitor (htop for GPU)

    # CUDA development (optional, can be per-project via nix-shell)
    # cudaPackages.cudatoolkit
    # cudaPackages.cudnn

    # Vulkan support
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
  ];

  # Boot parameters (optional optimizations)
  boot.kernelParams = [
    # "nvidia-drm.modeset=1"  # Already set by modesetting.enable
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"  # Better suspend/resume
  ];
}
```

**File: `configuration.nix` (Main System Config)**
```nix
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix  # Modular NVIDIA configuration
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "nixos-pc";

  # Time zone
  time.timeZone = "Your/Timezone";

  # Localization
  i18n.defaultLocale = "en_US.UTF-8";

  # User account
  users.users.yourusername = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.fish;
  };

  # Fish shell
  programs.fish.enable = true;

  # Desktop environment (choose one)
  # Option 1: KDE Plasma (best NVIDIA Wayland support)
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Option 2: Hyprland (tiling Wayland compositor)
  # programs.hyprland = {
  #   enable = true;
  #   xwayland.enable = true;
  # };

  # Docker for containerized ML workflows
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;  # GPU passthrough to containers
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    curl
    htop
    # Add your preferred tools
  ];

  # Allow unfree packages globally
  nixpkgs.config.allowUnfree = true;

  # NixOS version
  system.stateVersion = "24.11";  # Set to your NixOS release
}
```

### Data Science Environment (Per-Project Approach)

**Recommended: Use `flake.nix` per ML project**

**Example: PyTorch CUDA Development**

**File: `~/projects/ml-project/flake.nix`**
```nix
{
  description = "PyTorch CUDA Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.cudaSupport = true;
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Python with CUDA support
          python311
          python311Packages.pip
          python311Packages.virtualenv

          # CUDA toolkit
          cudaPackages.cudatoolkit
          cudaPackages.cudnn
          cudaPackages.nccl

          # Development tools
          python311Packages.jupyter
          python311Packages.ipython
        ];

        shellHook = ''
          # Set up CUDA environment
          export CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}
          export CUDNN_PATH=${pkgs.cudaPackages.cudnn}
          export EXTRA_LDFLAGS="-L${pkgs.cudaPackages.cudatoolkit}/lib -L${pkgs.cudaPackages.cudnn}/lib"
          export EXTRA_CCFLAGS="-I${pkgs.cudaPackages.cudatoolkit}/include -I${pkgs.cudaPackages.cudnn}/include"

          # Create/activate Python virtual environment
          if [ ! -d .venv ]; then
            python -m venv .venv
          fi
          source .venv/bin/activate

          # Install PyTorch with CUDA support (if not already installed)
          pip install --upgrade pip
          pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

          echo "CUDA Development Environment Ready"
          echo "CUDA Version: $(nvcc --version | grep release | awk '{print $5}' | sed 's/,//')"
          nvidia-smi
        '';
      };
    };
}
```

**Usage:**
```bash
cd ~/projects/ml-project
nix develop  # Enters dev shell with CUDA
# Now you have PyTorch + CUDA ready to use
```

---

## 6. Validation and Testing

### Post-Installation Checks

**1. Verify Driver Installation:**
```bash
nvidia-smi  # Should show RTX 3080 Ti, driver version, CUDA version
```

**2. Check Kernel Module (Open vs Proprietary):**
```bash
# Check which modules are loaded
lsmod | grep nvidia

# Verify open modules (if using open = true)
cat /proc/driver/nvidia/version
# Should mention "Open Kernel modules" if using open-source variant
```

**3. Test Wayland Compatibility:**
```bash
# Check if GBM backend is active
echo $GBM_BACKEND  # Should output: nvidia-drm

# Verify Wayland session
echo $XDG_SESSION_TYPE  # Should output: wayland
```

**4. Test CUDA:**
```bash
# Check CUDA compiler
nvcc --version

# Simple CUDA test (create test.cu)
cat << 'EOF' > test.cu
#include <stdio.h>
__global__ void hello() {
    printf("Hello from GPU!\n");
}
int main() {
    hello<<<1,1>>>();
    cudaDeviceSynchronize();
    return 0;
}
EOF

nvcc test.cu -o test
./test  # Should print: Hello from GPU!
```

**5. Test Vulkan:**
```bash
vulkaninfo | head -n 20  # Should show NVIDIA GPU
```

**6. Monitor GPU Usage:**
```bash
# CLI monitoring
nvtop  # Interactive GPU monitor

# GUI monitoring
nvidia-system-monitor-qt  # GPU usage GUI
```

---

## 7. Troubleshooting Common Issues

### Issue: Black Screen on Boot

**Cause:** Kernel mode-setting conflict

**Solution:**
```nix
# In nvidia.nix or configuration.nix
boot.kernelParams = [
  "nvidia-drm.modeset=1"
  "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
];
```

### Issue: Wayland Tearing/Flickering

**Cause:** Missing explicit sync (driver <555)

**Solution:** Upgrade to driver 555+
```nix
hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
# Ensure stable >= 555
```

### Issue: CUDA Not Found in Applications

**Cause:** Missing environment variables

**Solution:**
```bash
# Add to shell profile or flake.nix shellHook
export CUDA_PATH=/run/opengl-driver
export LD_LIBRARY_PATH=/run/opengl-driver/lib:$LD_LIBRARY_PATH
```

### Issue: Poor Performance on Wayland

**Cause:** Hardware cursor issues

**Solution:**
```nix
environment.sessionVariables = {
  WLR_NO_HARDWARE_CURSORS = "1";
};
```

---

## Summary and Recommendations

### For RTX 3080 Ti Data Science Workstation:

1. **Driver Choice:**
   - ✅ Use **latest stable driver** (currently 570/575/580 series)
   - ✅ Enable **open kernel modules** (`hardware.nvidia.open = true`)
   - ✅ Linux doesn't distinguish Studio vs Game Ready (use unified driver)

2. **Desktop Environment:**
   - 🏆 **Best:** KDE Plasma 6 (Wayland) - Excellent NVIDIA support, HDR
   - 🥈 **Alternative:** Hyprland (Wayland) - Tiling, lightweight, NVIDIA-friendly
   - ⚠️ **Avoid:** GNOME Wayland (historically problematic with NVIDIA)

3. **Critical Settings:**
   - ✅ `hardware.nvidia.modesetting.enable = true` (MANDATORY for Wayland)
   - ✅ `hardware.nvidia.open = true` (Use open modules)
   - ✅ Driver 555+ for explicit sync (tear-free Wayland)

4. **CUDA Development:**
   - ✅ Use per-project `flake.nix` for isolated environments
   - ✅ Latest stable driver ensures CUDA 12.x compatibility
   - ✅ NixOS's `/run/opengl-driver` provides driver libraries

5. **Open-Source Status:**
   - ⚠️ Kernel modules = Open (GPL/MIT)
   - ❌ Userspace = Still proprietary (CUDA, OpenGL, Vulkan libs)
   - ✅ Community can contribute to kernel modules

### Quick Start Flake Template:

See `nvidia.nix` configuration above for production-ready NixOS setup.

---

## References

- NixOS Wiki: https://wiki.nixos.org/wiki/Nvidia
- NVIDIA Open Modules: https://github.com/NVIDIA/open-gpu-kernel-modules
- NixOS NVIDIA Options: `hardware.nvidia.*` (see nixos-search)
- CUDA Compatibility: https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/

**Last Updated:** 2025-10-23
**Next Review:** After major driver release (585+) or NixOS 25.05 release

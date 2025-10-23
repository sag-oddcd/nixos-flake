# NVIDIA Compatibility Table (2024-2025)
## RTX 3080 Ti on NixOS

**Quick Reference for Installation Decision-Making**

---

## Feature Compatibility Matrix

| Feature | Status | Requirements | Notes |
|---------|--------|--------------|-------|
| **HDR (Wayland)** | ✅ **YES** | Driver 555+, KDE Plasma 6 or Hyprland | Full HDR support with compatible compositors |
| **HDR (X11)** | ⚠️ **Limited** | Depth-30 support available | Not full HDR like Wayland |
| **Wayland (General)** | ✅ **Excellent** | Driver 555+, modesetting enabled | GBM backend, explicit sync |
| **Wayland (Explicit Sync)** | ✅ **YES** | Driver 555+ (June 2024) | **Critical** - eliminates tearing |
| **Wayland (GBM)** | ✅ **YES** | Driver 545+ | Replaces legacy EGLStreams |
| **Wayland (Hyprland)** | ✅ **Works** | Driver 555+, modesetting | Excellent performance |
| **Wayland (KDE Plasma 6)** | ✅ **Best** | Driver 555+ | Recommended Wayland DE |
| **Wayland (Sway)** | ✅ **Works** | Driver 555+ | wlroots-based, good support |
| **Wayland (GNOME)** | ⚠️ **Works** | Driver 555+ | Historically problematic, improving |
| **NixOS Compatibility** | ✅ **Excellent** | Any NixOS version | First-class NVIDIA support |
| **CUDA 12.x** | ✅ **YES** | Driver 525+ | Full CUDA 12 support |
| **CUDA 11.x** | ✅ **YES** | Driver 450+ | Legacy CUDA support |
| **PyTorch + CUDA** | ✅ **Excellent** | CUDA 11.8 or 12.x | GPU acceleration works perfectly |
| **TensorFlow + CUDA** | ✅ **Excellent** | CUDA 11.8 or 12.x | GPU acceleration works perfectly |
| **JAX + CUDA** | ✅ **Excellent** | CUDA 11.8 or 12.x | GPU acceleration works perfectly |
| **Vulkan** | ✅ **Full** | Any driver version | Vulkan 1.3+ supported |
| **OpenGL** | ✅ **Full** | Any driver version | OpenGL 4.6 |
| **Ray Tracing (RTX)** | ✅ **Full** | RTX GPUs (3080 Ti ✅) | OptiX, RTX API support |
| **Video Encode (NVENC)** | ✅ **Full** | RTX 3080 Ti supports NVENC | H.264, H.265, AV1 |
| **Video Decode (NVDEC)** | ✅ **Full** | RTX 3080 Ti supports NVDEC | H.264, H.265, VP9, AV1 |
| **Multi-Monitor** | ✅ **YES** | Wayland preferred | Better than X11 |
| **Dynamic Power Management** | ✅ **YES** | Laptops, optional for desktop | Runtime PM available |
| **Docker + GPU** | ✅ **YES** | nvidia-docker or nvidia-container-toolkit | GPU passthrough to containers |

---

## NVIDIA Driver Variants

### Open vs Proprietary Kernel Modules

| Aspect | Open Modules | Proprietary Modules |
|--------|--------------|---------------------|
| **License** | GPL v2 + MIT | NVIDIA Proprietary |
| **Source Code** | Available on GitHub | Closed source |
| **Performance** | Identical | Identical |
| **CUDA Support** | Full (userspace still proprietary) | Full |
| **GPU Support** | Turing (RTX 20-series) or newer | All NVIDIA GPUs |
| **RTX 3080 Ti** | ✅ **Fully Supported** | ✅ **Fully Supported** |
| **NixOS Default** | ✅ Default on driver 560+ | Legacy default (<560) |
| **Recommendation** | ✅ **Use This** | Use only for older GPUs |
| **Configuration** | `hardware.nvidia.open = true` | `hardware.nvidia.open = false` |

**Verdict:** Use **open modules** for RTX 3080 Ti (Ampere architecture)

---

## Driver Versions (NixOS Packages)

| Package | Version Range | Use Case | Stability |
|---------|---------------|----------|-----------|
| `stable` | 570-580 (current) | **Recommended for production** | 🟢 Stable |
| `beta` | 585+ (testing) | Cutting-edge features | 🟡 Experimental |
| `production` | Long-term branch | Enterprise, older systems | 🟢 Very Stable |
| `legacy_470` | 470.x | Maxwell, Pascal GPUs | 🟢 Stable (old GPUs) |
| `legacy_390` | 390.x | Kepler GPUs | 🟢 Stable (very old) |
| `dc` | Data Center | Tesla, A100, H100 | 🟢 Stable (data center) |

**For RTX 3080 Ti:** Use `stable` (current: 570-580 series)

---

## Studio vs Game Ready (Linux Reality Check)

| Aspect | Windows | Linux/NixOS |
|--------|---------|-------------|
| **Driver Types** | Separate: Studio vs Game Ready | **Unified driver only** |
| **Gaming** | Game Ready | Unified (same as Game Ready) |
| **Creative Apps** | Studio | Unified (works for creative) |
| **Data Science** | Game Ready (faster updates) | Unified (no distinction) |
| **CUDA Development** | Game Ready | Unified (full CUDA support) |
| **Release Cadence** | Studio = slower, Game Ready = faster | Unified = matches Game Ready |

**Verdict:** On Linux/NixOS, there is **NO Studio vs Game Ready distinction**
- Use latest stable driver (equivalent to Windows "Game Ready")
- Data science workloads: **No benefit** from separate "Studio" driver
- CUDA works identically with unified Linux driver

---

## Recommended Configuration for Data Science

### Minimal (Essential)

```nix
hardware.nvidia = {
  open = true;                    # Use open kernel modules
  modesetting.enable = true;      # MANDATORY for Wayland
  package = config.boot.kernelPackages.nvidiaPackages.stable;
};

services.xserver.videoDrivers = [ "nvidia" ];
```

### Full-Featured (Recommended)

```nix
hardware.nvidia = {
  open = true;                    # Open kernel modules (RTX 3080 Ti supported)
  modesetting.enable = true;      # Kernel modesetting (Wayland requirement)
  nvidiaSettings = true;          # NVIDIA Settings GUI
  powerManagement.enable = false; # Desktop: false, Laptop: true
  package = config.boot.kernelPackages.nvidiaPackages.stable;
};

services.xserver.videoDrivers = [ "nvidia" ];

environment.sessionVariables = {
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  LIBVA_DRIVER_NAME = "nvidia";
  WLR_NO_HARDWARE_CURSORS = "1";  # Some compositors need this
};

boot.kernelParams = [
  "nvidia.NVreg_PreserveVideoMemoryAllocations=1"  # Better suspend/resume
];
```

---

## Desktop Environment Recommendations

| DE/Compositor | Wayland | NVIDIA Support | Data Science Workflow | Rating |
|---------------|---------|----------------|----------------------|--------|
| **KDE Plasma 6** | ✅ | ✅ Excellent | Professional, HDR, multi-monitor | 🏆 **Best** |
| **Hyprland** | ✅ | ✅ Excellent | Tiling, minimal, customizable | 🥈 **Great** |
| **Sway** | ✅ | ✅ Good | Tiling, i3-like, lightweight | 🥉 **Good** |
| **GNOME** | ✅ | ⚠️ Works | Improving, but historically problematic | ⚠️ **OK** |
| **KDE Plasma 5** | ❌ X11 | ✅ Good | Stable, but X11 limitations | 🟡 **X11 Fallback** |

**Recommendation:** KDE Plasma 6 (Wayland) for best NVIDIA experience + HDR support

---

## Critical Requirements Checklist

Before installing NixOS with NVIDIA:

- [ ] **NixOS unstable or 24.11+** (for latest driver support)
- [ ] **Driver 555+** (for Wayland explicit sync - eliminates tearing)
- [ ] **`hardware.nvidia.modesetting.enable = true`** (MANDATORY for Wayland)
- [ ] **`hardware.nvidia.open = true`** (RTX 3080 Ti supported)
- [ ] **Wayland compositor** (KDE Plasma 6 or Hyprland recommended)
- [ ] **`nixpkgs.config.allowUnfree = true`** (NVIDIA drivers are proprietary)

---

## CUDA Compatibility Quick Reference

| CUDA Version | Minimum Driver | Recommended Driver | Data Science Frameworks |
|--------------|----------------|--------------------|-----------------------|
| CUDA 12.6 | 560.28.03 | 570+ (stable) | PyTorch 2.5+, TensorFlow 2.18+ |
| CUDA 12.4 | 550.54.15 | 555+ | PyTorch 2.4+, TensorFlow 2.17+ |
| CUDA 12.0 | 525.60.13 | 530+ | PyTorch 2.0+, TensorFlow 2.15+ |
| CUDA 11.8 | 450.80.02 | 520+ | PyTorch 1.13+, TensorFlow 2.13+ |

**Current Stable (570-580):** Supports CUDA 12.6 and all previous versions

---

## Known Issues and Workarounds

| Issue | Cause | Solution | Status |
|-------|-------|----------|--------|
| **Black screen on boot** | Kernel mode-setting conflict | Add `nvidia-drm.modeset=1` to boot params | ✅ Fixed |
| **Wayland tearing** | No explicit sync (driver <555) | Upgrade to driver 555+ | ✅ Fixed in 555+ |
| **Flickering cursor** | Hardware cursor bug | Set `WLR_NO_HARDWARE_CURSORS=1` | ✅ Workaround |
| **GNOME Wayland issues** | GNOME-specific bugs | Use KDE Plasma 6 instead | ⚠️ Use different DE |
| **Suspend/resume problems** | Power management | Enable `powerManagement.enable = true` | ✅ Workaround |
| **CUDA not found** | Missing environment vars | Set `CUDA_PATH`, `LD_LIBRARY_PATH` | ✅ Configuration |

---

## Testing Commands

### Verify Installation

```bash
# Check driver and GPU
nvidia-smi

# Check kernel modules (open vs proprietary)
cat /proc/driver/nvidia/version

# Check Wayland session
echo $XDG_SESSION_TYPE  # Should be "wayland"

# Check GBM backend
echo $GBM_BACKEND  # Should be "nvidia-drm"
```

### Test CUDA

```bash
# CUDA compiler version
nvcc --version

# Quick CUDA test
nvidia-smi --query-gpu=name,compute_cap --format=csv
```

### Test Vulkan

```bash
vulkaninfo | grep -i "device name"
```

### Monitor GPU

```bash
# CLI (htop for GPU)
nvtop

# GUI
nvidia-system-monitor-qt
```

---

## Final Verdict for RTX 3080 Ti Data Science Setup

✅ **NVIDIA drivers are EXCELLENT on NixOS (2024-2025)**

**What Works:**
- ✅ Open-source kernel modules (RTX 3080 Ti fully supported)
- ✅ Wayland with explicit sync (driver 555+)
- ✅ HDR support (KDE Plasma 6)
- ✅ Full CUDA 12.x support for ML/AI workloads
- ✅ PyTorch, TensorFlow, JAX - all work perfectly
- ✅ Multi-monitor, high refresh rate, all modern features

**What to Use:**
- **Driver:** Latest stable (570-580 series) with open modules
- **Desktop:** KDE Plasma 6 (Wayland) for best experience
- **CUDA:** Per-project flakes for isolated environments
- **Config:** See `NVIDIA_DRIVERS_RESEARCH.md` for complete flake setup

**Bottom Line:** NixOS + NVIDIA + Wayland is **production-ready** for data science workstations in 2024-2025.

---

**Document Created:** 2025-10-23
**For:** RTX 3080 Ti | NixOS Installation | Data Science/CUDA Workstation
**See Also:** `NVIDIA_DRIVERS_RESEARCH.md` (comprehensive details)

# NixOS Flake Configuration

Complete NixOS configuration flake for jf's workstation.

## Features

### System Configuration
- **OS**: NixOS Unstable (bleeding-edge)
- **Bootloader**: Lanzaboote (Secure Boot support)
- **Kernel**: Latest Linux kernel
- **Display**: NVIDIA RTX 3080 Ti (proprietary drivers)
- **Storage**: Samsung 970 EVO 500GB (LUKS2 + LVM + Btrfs)
  - LUKS2 full disk encryption (password-only unlock)
  - LVM volume group with resizable swap and Btrfs volumes
  - Btrfs subvolumes: @, @home, @data, @snapshots
  - Zstd compression (level 1)
  - NVMe optimizations (TRIM, bypass workqueues)
- **Power Management**: Hibernate support (40GB swap)
- **Maintenance**: Btrfs auto-scrub (monthly), TRIM (weekly), firmware updates

### Desktop Environment
- **Compositor**: Pinnacle (Wayland)
- **Terminal**: Wezterm
- **Shell**: Fish
- **Launcher**: Onagre
- **File Manager**: Yazi
- **Display Manager**: greetd + greetrs-tui

### Development Tools
- **Editor**: Neovim (nightly) with lazy.nvim + mason.nvim
- **Rust**: Nightly toolchain via rust-overlay + swiftly
- **Node.js**: Bun (primary), Node.js 22 (fallback)
- **Python**: UV package manager + Python 3.12
- **Go**: Latest
- **Zig**: Latest + ZLS

### Rust-Native CLI Tools (45+)
- **File Ops**: bat, eza, fd, ripgrep, sd, choose
- **Navigation**: zoxide, fzf
- **VCS**: git, jujutsu, gitui, delta, lazygit
- **Monitoring**: bottom (btm), procs, gping
- **Productivity**: atuin, starship, watchexec
- **Task Runners**: just
- **Dotfiles**: dotter
- **Data**: jq, jaq
- **Misc**: du-dust, dua, tealdeer, tokei, hyperfine

### Linters & Formatters
- **JS/TS/JSON**: Biome, dprint
- **Python**: Ruff
- **Lua**: StyLua
- **Rust**: rustfmt, clippy
- **Shell**: shfmt, shellcheck
- **YAML**: yamllint, dprint
- **Markdown**: dprint
- **Nix**: nixpkgs-fmt, alejandra, statix, deadnix

### Applications
- **Browsers**: qutebrowser (primary), brave-nightly, vivaldi-snapshot
- **Passwords**: 1Password
- **Text Expansion**: Espanso
- **Themes**: Tinty
- **Screenshots**: Wayshot
- **Lock**: Waylock
- **Input**: Kanata (keyboard remapping)

## Installation

### 1. Boot NixOS ISO
Boot from NixOS installation media (USB created with Ventoy).

### 2. Partition Disk (LUKS2 + LVM + Btrfs)

**For complete installation guide with LUKS2 encryption, see:**
- `docs/PARTITIONING_CONFIG.md` - Architecture reference
- `../worktree-partitioning-security/INSTALLATION_GUIDE.md` - Step-by-step guide

**Quick overview:**
```bash
# 1. Create partitions
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart BOOT ext4 512MiB 2GiB
parted /dev/nvme0n1 -- mkpart LUKS 2GiB 100%

# 2. Setup LUKS2 encryption
cryptsetup luksFormat --type luks2 /dev/nvme0n1p3
cryptsetup open /dev/nvme0n1p3 cryptlvm

# 3. Setup LVM
pvcreate /dev/mapper/cryptlvm
vgcreate vg0 /dev/mapper/cryptlvm
lvcreate -L 40G vg0 -n swap-lv
lvcreate -l 100%FREE vg0 -n btrfs-lv

# 4. Format filesystems
mkfs.fat -F 32 -n EFI /dev/nvme0n1p1
mkfs.ext4 -L BOOT /dev/nvme0n1p2
mkswap -L SWAP /dev/vg0/swap-lv
mkfs.btrfs -L NIXOS /dev/vg0/btrfs-lv

# 5. Create Btrfs subvolumes
mount /dev/vg0/btrfs-lv /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@data
btrfs subvolume create /mnt/@snapshots
umount /mnt

# 6. Mount everything
mount -o compress=zstd:1,subvol=@ /dev/vg0/btrfs-lv /mnt
mkdir -p /mnt/{home,data,.snapshots,boot,boot/efi}
mount -o compress=zstd:1,subvol=@home /dev/vg0/btrfs-lv /mnt/home
mount -o compress=zstd:1,subvol=@data /dev/vg0/btrfs-lv /mnt/data
mount -o compress=zstd:1,subvol=@snapshots /dev/vg0/btrfs-lv /mnt/.snapshots
mount /dev/nvme0n1p2 /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot/efi
swapon /dev/vg0/swap-lv
```

### 3. Generate Hardware Config
```bash
nixos-generate-config --root /mnt
```

### 4. Copy This Flake
```bash
# Copy flake files to /mnt/etc/nixos/
cp flake.nix /mnt/etc/nixos/
cp configuration.nix /mnt/etc/nixos/
cp home.nix /mnt/etc/nixos/

# Replace template hardware-configuration.nix with generated one
# (The generated file is already at /mnt/etc/nixos/hardware-configuration.nix)
```

### 5. Update Git Config
Edit `/mnt/etc/nixos/home.nix` and update:
```nix
programs.git = {
  userName = "jf";
  userEmail = "your-email@example.com";  # Update this!
};

programs.jujutsu = {
  settings = {
    user = {
      email = "your-email@example.com";  # Update this!
    };
  };
};
```

### 6. Install
```bash
nixos-install --flake /mnt/etc/nixos#nixos-workstation
```

### 7. Set Password
```bash
nixos-enter --root /mnt
passwd jf
exit
```

### 8. Reboot
```bash
reboot
```

## Post-Installation

### 1. Setup Secure Boot (Lanzaboote)
```bash
# Generate Secure Boot keys
sudo sbctl create-keys

# Enroll keys
sudo sbctl enroll-keys -m

# Verify Secure Boot status
sbctl status

# After next rebuild, sign all kernels
sudo nixos-rebuild switch
```

### 2. Fisher Plugins
```fish
# Install recommended Fisher plugins
fisher install jethrokuan/z
fisher install PatrickF1/fzf.fish
fisher install jorgebucaran/autopair.fish
```

### 2. Neovim Setup
```bash
# Install lazy.nvim plugins
nvim
# lazy.nvim will auto-install on first run
```

### 3. Atuin Sync
```fish
# Register/login to Atuin
atuin register
# or
atuin login
```

### 4. Claude Code
```bash
# Install Claude Code (native installer)
curl -fsSL https://claude.com/install.sh | sh

# Configure MCP servers as needed
claude mcp add context7 -- $CLAUDE_PNPM_BIN dlx @context7/server
# ... etc
```

### 5. 1Password
```bash
# Sign in to 1Password
op signin
```

## Updating

```bash
# Update flake inputs
nix flake update

# Rebuild system
sudo nixos-rebuild switch --flake /etc/nixos#nixos-workstation

# Or just:
sudo nixos-rebuild switch
```

## Validation

This flake has been validated with:
- alejandra (Nix formatter)
- statix (Nix linter)
- deadnix (Dead code detector)
- nixd (LSP diagnostics)
- NixOS MCP semantic validation

## Troubleshooting

### NVIDIA Issues
If NVIDIA drivers don't load:
```bash
# Check driver loaded
lsmod | grep nvidia

# Check Xorg log
journalctl -u display-manager
```

### Wayland on NVIDIA
Ensure these are set (already in configuration.nix):
```nix
environment.sessionVariables = {
  WLR_NO_HARDWARE_CURSORS = "1";
  NIXOS_OZONE_WL = "1";
};
```

### Boot Issues
Access emergency shell and check:
```bash
journalctl -xb
```

## Structure

```
.
├── flake.nix                          # Main flake entry point
├── flake.lock                         # Locked dependencies
├── hosts/
│   └── nixos-workstation/
│       ├── default.nix                # Host configuration (imports all modules)
│       └── hardware-configuration.nix # Samsung 970 EVO LUKS+LVM+Btrfs setup
├── modules/
│   ├── system/
│   │   ├── boot.nix                   # Lanzaboote (Secure Boot)
│   │   ├── storage.nix                # Btrfs scrub, TRIM, firmware updates
│   │   ├── packages.nix               # System packages (incl. disk/security tools)
│   │   └── ...                        # Other system modules
│   └── hardware/
│       ├── cpu-amd.nix                # AMD CPU optimizations
│       ├── nvme.nix                   # Samsung NVMe optimizations
│       └── ...                        # Other hardware modules
├── home/
│   └── jf/                            # Home Manager user config
├── overlays/
│   └── beautyline-garuda-overlay.nix  # BeautyLine icon theme
├── docs/
│   ├── PARTITIONING_CONFIG.md         # LUKS+LVM+Btrfs architecture reference
│   └── theming/                       # Icon theme documentation
├── STREAMPAGER_AVAILABILITY.md        # Streampager pager availability & setup
└── README_FLAKE.md                    # This file
```

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [Awesome Nix](https://github.com/nix-community/awesome-nix)
# Auto-commit test 02:48:52
# Test 2: 02:49:45
# Auto-watcher test: 02:52:31

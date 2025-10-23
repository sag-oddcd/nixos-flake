# NixOS Flake Configuration

Complete NixOS configuration flake for jf's workstation.

## Features

### System Configuration
- **OS**: NixOS Unstable (bleeding-edge)
- **Bootloader**: systemd-boot
- **Kernel**: Latest Linux kernel
- **Display**: NVIDIA RTX 3080 Ti (proprietary drivers)
- **Storage**: Samsung NVMe (optimized)

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

### 2. Partition Disk
```bash
# Example partitioning (adjust as needed)
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart primary 512MiB 100%

# Format
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.ext4 -L nixos /dev/nvme0n1p2

# Mount
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
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

### 1. Fisher Plugins
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
├── flake.nix                    # Main flake entry point
├── flake.lock                   # Locked dependencies
├── configuration.nix            # System configuration
├── hardware-configuration.nix   # Hardware-specific config (generated)
└── home.nix                     # Home Manager user config
```

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [Awesome Nix](https://github.com/nix-community/awesome-nix)
# Auto-commit test 02:48:52
# Test 2: 02:49:45

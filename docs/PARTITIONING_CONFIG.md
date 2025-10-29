# Partitioning & Security Configuration Reference
## From worktree-partitioning-security

This worktree contains the NixOS configuration files designed for the partitioning and security setup documented in `worktree-partitioning-security`.

---

## Configuration Files

### `hardware-configuration.nix`
Hardware-specific configuration for Samsung 970 EVO 500GB with:
- LUKS2 encryption setup
- LVM volume group (vg0) with swap-lv and btrfs-lv
- Btrfs subvolume mounts (@, @home, @data, @snapshots)
- Hibernate resume configuration
- NVMe SSD optimizations (TRIM, bypass workqueues)

**⚠️ Requires customization:**
- Replace UUID placeholders after partitioning:
  - `REPLACE-WITH-NVME0N1P1-UUID` (ESP)
  - `REPLACE-WITH-NVME0N1P2-UUID` (/boot)
  - `REPLACE-WITH-NVME0N1P3-UUID` (LUKS container)

### `configuration.nix`
System-wide NixOS configuration with:
- Lanzaboote (Secure Boot support)
- Essential system packages
- User configuration template
- Btrfs auto-scrub (monthly)
- TRIM scheduling (weekly)
- Hibernate support

**⚠️ Requires customization:**
- `networking.hostName` - Your hostname
- `time.timeZone` - Your timezone
- `users.users.yourusername` - Your username and details
- `hardware.cpu.intel.updateMicrocode` - Change to AMD if needed

---

## Partition Architecture

These configurations implement the following disk layout:

```
Samsung 970 EVO 500GB (nvme0n1)
├─ nvme0n1p1 (512M)    → /boot/efi    [FAT32, unencrypted]
├─ nvme0n1p2 (1.5G)    → /boot        [ext4, unencrypted]
└─ nvme0n1p3 (498G)    → LUKS2 encrypted container
                         └─ vg0 (LVM volume group)
                            ├─ swap-lv (40G)    → swap [hibernate]
                            └─ btrfs-lv (458G)  → Btrfs filesystem
                               ├─ @            → /
                               ├─ @home        → /home
                               ├─ @data        → /data
                               └─ @snapshots   → /.snapshots
```

---

## Key Features

**Security:**
- LUKS2 full disk encryption (password-only unlock)
- Secure Boot enabled via Lanzaboote
- Encrypted swap for secure hibernation

**Flexibility:**
- LVM: Resizable swap and Btrfs volumes
- Btrfs subvolumes: Dynamic space allocation
- Compression: zstd:1 (~20-30% space savings)

**Reliability:**
- Snapshots for system rollback
- Monthly Btrfs scrub (data integrity)
- Weekly TRIM (SSD longevity)

---

## Installation Reference

For complete installation instructions, see:
`/home/jf/projects/pc_black_screen_of_death/worktree-partitioning-security/INSTALLATION_GUIDE.md`

For recovery procedures, see:
`/home/jf/projects/pc_black_screen_of_death/worktree-partitioning-security/RECOVERY_GUIDE.md`

For architecture overview, see:
`/home/jf/projects/pc_black_screen_of_death/worktree-partitioning-security/OVERVIEW.md`

---

## Integration with Flake

These configuration files can be integrated into a NixOS flake structure:

```nix
# Example flake.nix structure
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lanzaboote }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        lanzaboote.nixosModules.lanzaboote
        ./hardware-configuration.nix
        ./configuration.nix
      ];
    };
  };
}
```

---

## Post-Installation Tasks

After installation with these configurations:

1. **Immediate:**
   - Get UUIDs: `sudo blkid`
   - Update `hardware-configuration.nix` with actual UUIDs
   - Customize `configuration.nix` (hostname, user, timezone)
   - Run: `sudo nixos-rebuild switch`

2. **Security:**
   - Create LUKS backup keyfile
   - Backup Secure Boot keys from `/etc/secureboot/`
   - Test hibernate: `systemctl hibernate`

3. **Maintenance:**
   - Setup Btrfs snapshot automation (snapper/btrbk)
   - Configure regular backups to external storage
   - Document LUKS password in secure location

---

## Design Decisions

**Why LVM + Btrfs hybrid?**
- LVM: Easy swap resizing (critical for hibernate requirement)
- Btrfs: Dynamic space allocation between subvolumes
- Combined: Maximum flexibility for future changes

**Why separate @, @home, @data subvolumes?**
- `@`: System files (replaceable)
- `@home`: User configs (distro-specific for multi-boot)
- `@data`: Personal files (shared across distros)
- Independent snapshots and rollback per subvolume

**Why password-only LUKS unlock?**
- Maximum security (no TPM dependency)
- Simple recovery (just need password)
- Clear failure mode (no auto-unlock confusion)

---

## Related Documentation

**In worktree-partitioning-security:**
- `INSTALLATION_GUIDE.md` - Step-by-step installation
- `RECOVERY_GUIDE.md` - Emergency procedures
- `OVERVIEW.md` - Architecture summary
- `CLAUDE.md` - Complete design rationale

**In this worktree:**
- These configuration files are the implementation
- To be integrated into NixOS flake structure

---

**Source worktree:** `worktree-partitioning-security` (branch: partitioning-security)
**Date created:** 2025-10-28
**Hardware:** Samsung 970 EVO 500GB (MZ-V7E500E)
**RAM:** 32GB (40GB swap for hibernate)

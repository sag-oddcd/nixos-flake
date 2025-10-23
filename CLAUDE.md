# Worktree: NixOS Flake Recipe Recovery

## Objective

Locate and document the complete NixOS flake recipe previously used for system configuration, to enable flake-based NixOS installation instead of traditional configuration.nix.

## Background

User has previously worked with a complete NixOS flake configuration but cannot currently access it due to:
- Windows partition inaccessible (BCD corrupted)
- WSL instances unavailable (stored on Windows partition)
- Potential locations in Windows Documents, Desktop, or WSL rootfs

## Environment Constraints

**CRITICAL: OOM/Crash Prevention (Signal 9 / Futex Errors)**
- ⚠️ **DO NOT run these memory-intensive operations:**
  - ❌ `cargo build/install/compile` - Always use pre-built binaries
  - ❌ `fish_indent` - Causes immediate crash (missing or broken)
  - ❌ `WebSearch` tool - Can trigger OOM
  - ❌ Large `jq` operations on history.jsonl (>100KB files)
  - ❌ Complex multi-pipe commands with multiple subshells
  - ❌ Any command spawning multiple processes simultaneously
- **Cause:** OOM (Out-of-Memory) in Android/Termux proot environment (limited RAM)
- **Symptoms:** Signal 9, futex facility errors, process killed
- **Safe alternatives:**
  - Use `cargo binstall` instead of `cargo install`
  - Skip fish formatting, use syntax validation only (`fish -n`)
  - Avoid WebSearch, use WebFetch for specific URLs
  - Use `head`/`tail` to limit jq operations
  - Keep commands simple and sequential
- **Context:** Running in Termux/Android proot Debian with severe memory constraints

## Search Results (Local)

### Completed Searches ✅

**1. Claude Code History** (`~/.claude/history.jsonl`)
- Size: 104KB
- Result: ❌ No flake.nix found
- References: 1 mention of "flake" (validation context, not migration recipe)
- Related project: `/home/jf/projects/nix-on-droid`

**2. Termux/Proot Filesystem** (`/home/jf/**`)
- Search: `**/*.nix` across entire home directory
- Found: 3 files (none are migration recipes)

**Files Found:**

```
/home/jf/projects/nix-on-droid/claude-code-isolated.nix
- Type: Nix package for isolated Claude Code
- Content: Derivation with Node.js, Python, uv dependencies
- Relevance: ❌ Not a NixOS migration recipe

/home/jf/projects/nix-on-droid/shell.nix
- Type: Development shell environment
- Content: mkShell with isolated runtimes and LSP servers
- Relevance: ❌ Not a NixOS migration recipe

/home/jf/projects/nix-on-droid/nix-validation-config.nix
- Type: Validation tools configuration
- Content: statix, deadnix, nixpkgs-fmt, nil
- Relevance: ❌ Not a NixOS migration recipe
```

**Supporting Documents Found:**

```
/home/jf/projects/nix-on-droid/FLAKE_VALIDATION_GUIDE.md
- Content: Flake validation workflow, linting tools, example flake
- Value: ✅ Reference for creating new flake
- Contains: Basic flake structure, validation pipeline
- Missing: Complete migration recipe with hardware config
```

**3. Project Scan**
- `/home/jf/projects/nix-on-droid/` → nix-on-droid configs only
- `/home/jf/projects/nixos-avf/` → Empty directory
- Other 8 projects → No NixOS-related content

### Inaccessible Locations 🔒

**Windows Partition (nvme0n1p3)**
- Status: Currently unavailable (BCD corrupted)
- Potential locations:
  - `C:\Users\<username>\Documents\nixos-config\`
  - `C:\Users\<username>\Projects\dotfiles\`
  - `C:\Users\<username>\Desktop\`
  - `C:\Users\<username>\Downloads\`
- Access method: Mount read-only after NixOS installation

**WSL Partitions**
- Ubuntu WSL: `/home/<username>/.config/nixos/`
- NixOS WSL: `/etc/nixos/flake.nix`
- Storage location: `C:\Users\<username>\AppData\Local\Packages\*\LocalState\rootfs\`
- Access method: Navigate through mounted Windows partition

**claude.ai Conversations**
- Status: No API access via Claude Code
- Alternative: Manual browser access required
- Search terms: "flake.nix", "NixOS migration", "hardware-configuration"

## Recovery Strategy

### Option A: Install with Basic config.nix + Recover Later (RECOMMENDED)

**Advantages:**
- ✅ Faster (installation guide ready)
- ✅ Lower risk (original recipe may exist)
- ✅ Allows Windows file recovery first
- ✅ Flake migration can be done post-installation

**Process:**
1. Install NixOS using `worktree-migracao/NIXOS_INSTALL_GUIDE.txt`
2. Boot into NixOS
3. Mount Windows partition read-only
4. Search for flake recipe in:
   - Windows Documents
   - Windows Desktop
   - WSL rootfs directories
   - Windows Downloads
5. If found → migrate configuration.nix to flake
6. If not found → proceed to Option B

### Option B: Create New Flake Recipe Now

**Advantages:**
- ✅ Start with flake from day 1
- ✅ Modern, reproducible configuration
- ✅ Modular structure

**Requirements:**
- Hardware specs: Gigabyte + Samsung NVMe + RTX 3080 Ti
- Software needs: NVIDIA drivers (proprietary), Fish shell, development tools
- Pattern: Flake with Home Manager integration

**Template structure:**
```nix
{
  description = "NixOS PC Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations.nixos-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
```

## Next Steps

### Immediate (After NixOS Installation)

1. **Mount Windows partition:**
   ```bash
   sudo mkdir -p /mnt/windows
   sudo mount -o ro /dev/nvme0n1p3 /mnt/windows
   ```

2. **Search for flake recipe:**
   ```bash
   # Documents
   find /mnt/windows/Users/*/Documents -name "flake.nix" 2>/dev/null
   find /mnt/windows/Users/*/Documents -name "*nixos*" -type d 2>/dev/null

   # Desktop
   find /mnt/windows/Users/*/Desktop -name "*.nix" 2>/dev/null

   # WSL rootfs
   find /mnt/windows/Users/*/AppData/Local/Packages -name "flake.nix" 2>/dev/null

   # Downloads
   find /mnt/windows/Users/*/Downloads -name "*nix*" 2>/dev/null
   ```

3. **Document findings:**
   - If found: Copy to NixOS, analyze structure
   - If not found: Create new flake using Option B

### Future Work

**If Recipe Found:**
- Validate with statix/deadnix (tools available in nix-on-droid project)
- Adapt hardware-configuration.nix for current system
- Test with `nix flake check`
- Build and deploy

**If Recipe Not Found:**
- Use FLAKE_VALIDATION_GUIDE.md as reference
- Create modular flake structure
- Integrate Home Manager
- Version control in this worktree

## Reference Files

**In This Worktree:**
- `BUSCA_RECEITA_FLAKE.md` - Detailed search report
- `CLAUDE.md` - This file

**In nix-on-droid Project:**
- `FLAKE_VALIDATION_GUIDE.md` - Flake creation and validation guide
- `claude-code-isolated.nix` - Example Nix derivation
- `shell.nix` - Example dev shell
- Validation tools: statix, deadnix, nixpkgs-fmt, nil

**In Migration Worktree:**
- `NIXOS_INSTALL_GUIDE.txt` - Installation procedure
- Basic configuration.nix with NVIDIA support

## Search Commands Reference

```bash
# Global .nix file search
find /home/jf -name "*.nix" -type f 2>/dev/null

# Flake-specific search
find /home/jf -name "flake.nix" -type f 2>/dev/null

# Directory search for nixos configs
find /home/jf -name "*nixos*" -type d 2>/dev/null

# Content search in .nix files
grep -r "flake" /home/jf --include="*.nix" 2>/dev/null

# Claude Code history search
grep -i "flake\|configuration.nix\|nixos" ~/.claude/history.jsonl
```

## Coordination with Other Worktrees

**worktree-migracao:**
- Primary focus: Install NixOS first
- Dependency: This worktree needs NixOS running to access Windows files
- Handoff: After installation complete, return here for flake search

**master:**
- Overall project tracking
- Consolidates status from both worktrees

## Success Criteria

1. ✅ Flake recipe located and validated
2. ✅ Recipe adapted for current hardware
3. ✅ Successfully builds with `nix flake check`
4. ✅ NixOS system running from flake configuration

OR (if not found):

1. ✅ New flake created following best practices
2. ✅ Modular structure with Home Manager
3. ✅ Validated with statix/deadnix
4. ✅ System running from new flake

## Timeline

- **Phase 1:** Wait for NixOS installation (worktree-migracao)
- **Phase 2:** Mount Windows and search (15-30 minutes)
- **Phase 3a:** If found → adapt and deploy (1-2 hours)
- **Phase 3b:** If not found → create new (3-4 hours)

## Notes

- Keep basic configuration.nix as backup
- Document all changes when migrating to flake
- Use git to track flake evolution
- Test thoroughly before deleting Windows partition

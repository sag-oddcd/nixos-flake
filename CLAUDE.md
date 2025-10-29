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

---

## Project Log

### 2025-10-24 21:30 - FINDING: Note 9 Model Identified as SM-N960F/DS

**Impact:** High

**Details:**
Identified exact phone model as SM-N960F/DS (Exynos 9810, Dual SIM) based on:
- Brazilian market acquisition (February 2020)
- 128GB/6GB RAM configuration
- Dual SIM requirement ("Dual Chip" in specs)
- Cross-referenced with market distribution patterns

This model has **unlockable bootloader** - excellent rootability for creating bootable USB via EtchDroid.

**Artifacts:**
- `/storage/emulated/0/pre-zold5_owned_phone.txt` (source specs)
- Research confirmed: SM-N960F/DS = Exynos variant (best for rooting)

**Next Steps:**
- Proceed with TWRP + Magisk rooting process
- Download SM-N960F-specific TWRP recovery image
- Install EtchDroid for USB bootable creation

---

### 2025-10-24 21:35 - RESOLUTION: Linux Distro Experimentation Strategy

**Impact:** Medium

**Details:**
Resolved Linux distro experimentation requirement with production-ready criteria:
- **Bare metal Linux:** NOT feasible (no production-ready ports exist for Note 9)
- **Selected solution:** Hybrid approach (Root + Stock Android + Nix-on-Droid)
- **Rationale:** Only option meeting all criteria:
  - ✅ Compatible with SM-N960F/DS
  - ✅ Production-ready (stable releases)
  - ✅ Actively maintained (2024 releases)

**Strategy:**
1. Primary goal: Root Note 9 → EtchDroid → Create NixOS bootable USB
2. Secondary goal: Nix-on-Droid → Linux experimentation (proot environment)
3. No conflict: Both coexist on rooted Android without interfering

**Artifacts:**
- Research outputs:
  - `/tmp/bootable_usb_research.md` (comprehensive tool analysis)
  - `/tmp/quick_reference.md` (TL;DR guide)
- Existing project: `/home/jf/projects/nix-on-droid/`

**Next Steps:**
- Wait for Note 9 battery to reach 70%+
- Execute rooting process (TWRP + Magisk)
- Install EtchDroid and Nix-on-Droid APKs

---

### 2025-10-24 21:49 - ARTIFACT: Project Documentation Protocol

**Impact:** Medium

**Details:**
Created `project-documenting` skill as structured guideline for maintaining progressive project log.

**Purpose:**
- Systematic tracking of findings, resolutions, artifacts, goals, blockers
- Structured format: timestamps, categories, impact levels, next steps
- Updates project-memory (CLAUDE.md) progressively
- Main assistant follows protocol after significant events

**Implementation:**
- NOT a background worker (Claude Code doesn't support persistent processes)
- Main assistant invokes protocol mentally after milestones
- Maintains chronological log in "## Project Log" section

**Artifacts:**
- Source: `~/projects/skills/project-documenting/SKILL.md`
- Target: `~/.claude/skills/project-documenting/SKILL.md` (symlinked via dotter)
- Dotter config: `~/projects/skills/.dotter/global.toml`

**Next Steps:**
- Main assistant follows protocol throughout project
- Document each significant milestone as it occurs
- Maintain structured, chronological log

---

### 2025-10-24 21:50 - BLOCKER: Note 9 Battery Charging

**Impact:** High

**Details:**
Cannot proceed with rooting process - Note 9 battery currently charging.
Rooting requires >70% battery to prevent bricking during:
- Bootloader unlock (wipes device)
- TWRP recovery flash (critical operation)
- Initial Magisk installation

**Current Status:**
- Battery: Charging in progress
- ETA to 70%: Unknown (user monitoring)

**Workaround:**
While waiting, can:
- Download required tools/ISOs to Termux
- Prepare step-by-step rooting guide
- Review TWRP installation procedures

**Next Steps:**
- Monitor battery level (user responsibility)
- Resume rooting at 70%+ battery
- Download TWRP, Magisk, NixOS ISO, EtchDroid APK

---

### 2025-10-24 22:32 - ARTIFACT: User-Prompt-Submit-Hook for Assistant Reminders

**Impact:** Medium

**Details:**
Created `user-prompt-submit-hook` system to inject skill reminders before each assistant response cycle.

**How it works:**
1. Hook triggers after every user message (before assistant processing)
2. Reads reminders from `~/.claude/assistant-reminders.txt`
3. Injects content as `<assistant-reminders>` block
4. Assistant sees reminders as "last thing" before generating response

**Current reminders (2 active):**
- Use parallel workers for multi-faceted requests (task-parallelizing skill)
- Document findings/resolutions progressively in CLAUDE.md (project-documenting skill)

**Artifacts:**
- Source: `~/projects/hooks/user-prompt-submit-hook.sh`
- Target: `~/.claude/hooks/user-prompt-submit-hook.sh` (symlinked via dotter)
- Reminders: `~/.claude/assistant-reminders.txt`
- Dotter config: `~/projects/hooks/.dotter/global.toml`
- Settings: `~/.claude/settings.json` (hooks.UserPromptSubmit registered)

**Next Steps:**
- Hook will activate on next user message
- Can add/modify reminders by editing assistant-reminders.txt
- Future: Add retrieval-router reminder (item 3 from proposed list)

---

### 2025-10-28 - ARTIFACT: Language Tooling Research Complete

**Impact:** High

**Details:**
Completed comprehensive research on linters, formatters, and LSP servers for 25 programming languages. Research conducted via 3 parallel workers across awesome-rust, awesome-go, awesome-zig catalogs.

**Coverage:**
- ✅ 18 languages with Rust/Go/Zig tools (72%)
- ✅ 11 languages with complete linter + formatter
- ✅ 7 production-ready Rust/Go/Zig LSP servers
- ✅ 100% syntax highlighting via tree-sitter (Rust)

**Breakthrough Discoveries:**
- **Biome** (Rust) - Multi-language powerhouse: JS/TS/JSON/CSS/HTML
- **mago** (Rust) - PHP linter + formatter (first Rust PHP tool found)
- **ruff** (Rust) - Python unified linter + formatter (10-100x faster)
- **6 Markdown linters** (Rust) - mado, rumdl, quickmark, checkmark, mdlinker, mdcheck

**Markdown Tooling Decision:**
Selected **Option C: Maximum Coverage** for documentation quality:
- **checkmark** (Rust) - AI-powered spell check + link validation
- **rumdl** (Rust) - Unified linter + formatter (only tool with both)

**Artifacts:**
- `TOOLING_RESEARCH.md` (520 lines) - Complete language analysis
- `LSP_SERVER_CATALOG.md` (895 lines) - LSP servers by implementation language
- `TOOLING_INTEGRATION_GUIDE.md` (270 lines) - NixOS flake integration strategy
- `TOOLING_PRIMARY_SOURCES.md` (62 lines) - Research catalog directory

**Key Findings:**
1. Rust dominates modern tooling (Biome, ruff, mago, selene, taplo, stylua)
2. Go strong in infrastructure (golangci-lint, shfmt, gopls, cuepls)
3. 16 languages require TypeScript/Node.js LSP servers (hybrid approach needed)
4. dprint (Rust) provides unified formatter framework for 10+ languages

**Integration Strategy:**
- Tier 1: Biome, ruff, taplo, clippy, rustfmt, dprint
- Tier 2: selene, stylua, statix, deadnix, nixfmt, golangci-lint, shfmt
- Tier 3: mago (PHP), checkmark + rumdl (Markdown), oxlint (JS/TS alt)
- Tier 4: Same-language fallback (clang-format, google-java-format, dotnet format)

**Next Steps:**
- Integrate selected tools into NixOS flake configuration
- Use isolated Node.js runtime ($CLAUDE_PNPM_BIN) for TypeScript LSP servers
- Test tooling stack with code-validating skill (supports 21 languages)
- Document tool installation in systemPackages

---

### 2025-10-28 - ARTIFACT: NixOS Package Availability Matrix Complete

**Impact:** High

**Details:**
Completed systematic verification of all 28 current development tools (non-deprecated only) across nixpkgs channels and community overlays using hybrid approach (nixos MCP server + Sourcegraph code search).

**Results:**
- ✅ **26/28 tools available in nixpkgs** (92.9%)
- ⚠️ **1/28 pending channel release** (rumdl - in source but not channels)
- ❌ **1/28 missing** (checkmark - cargo install required)

**Key Discoveries:**

1. **rumdl Mystery Solved:**
   - Sourcegraph: ✅ Found at `pkgs/by-name/ru/rumdl/package.nix`
   - MCP search: ❌ Not found in unstable/stable channels
   - **Conclusion:** Package added to nixpkgs master but not yet released to channels
   - **ETA:** Should appear in unstable within 1-2 weeks

2. **checkmark Unavailable:**
   - Not found in nixpkgs, NUR, or home-manager overlays
   - Alternative: `cargo install checkmark` or skip AI validation
   - Decision needed: AI spell check worth cargo install?

**Tool Categories:**

**Tier 1 (Core): 6/6 available** ✅
- biome, ruff, taplo, clippy, rustfmt, dprint

**Tier 2 (Language-specific): 9/9 available** ✅
- selene, stylua, statix, deadnix, nixfmt, alejandra, nixpkgs-fmt, golangci-lint, shfmt

**Tier 3 (Specialized): 1/3 available now** ⚠️
- ✅ mago (PHP)
- ⚠️ rumdl (pending channel release)
- ❌ checkmark (cargo install required)

**Tier 4 (Fallback): 3/3 available** ✅
- clang-tools, cppcheck, google-java-format

**LSP Servers: 4/4 available** ✅
- rust-analyzer, gopls, zls, nixd

**Supporting Tools: 3/3 available** ✅
- tree-sitter, nushell, cue

**Artifacts:**
- `NIX_PACKAGE_AVAILABILITY.md` - Complete 200-line availability matrix with:
  - Tool-by-tool breakdown with versions
  - Missing package analysis with alternatives
  - Installation strategy by tier
  - Verification methodology

**Installation Strategy:**

```nix
environment.systemPackages = with pkgs; [
  # Available now (26 tools)
  biome ruff taplo clippy rustfmt dprint
  selene stylua statix deadnix nixfmt alejandra nixpkgs-fmt
  golangci-lint shfmt mago
  clang-tools cppcheck google-java-format
  rust-analyzer gopls zls nixd
  tree-sitter nushell cue

  # After rumdl hits channels (add when available):
  # rumdl
];
```

**Cargo fallback (if needed):**
```bash
cargo install checkmark  # If AI validation required
cargo install rumdl      # If can't wait for channel release
```

**Verification Method:**
- Primary: nixos MCP server (mcp-nixos v1.0.0)
- Fallback: Sourcegraph search of NixOS/nixpkgs repository
- Overlay search: nix-community/NUR, nix-community/home-manager (no matches)

**Next Steps:**
1. ✅ Package availability verification complete
2. ⏳ Update TOOLING_INTEGRATION_GUIDE.md with nixpkgs package names
3. ⏳ Decide: Install checkmark via cargo or skip AI validation
4. ⏳ Monitor rumdl in unstable channel (check weekly)
5. ⏳ Test 26-tool installation in NixOS flake configuration
6. ⏳ Validate with code-validating skill after installation

**Success Metrics:**
- 96.4% availability after rumdl release (27/28 tools)
- Zero external overlays required
- Zero deprecated tools included
- Single cargo install needed (checkmark) if AI validation desired

---

## 2025-10-28 - INTEGRATION: BeautyLine Icon Theme (Garuda Fork)

**Impact:** Medium-High (Desktop theming)

**Summary:**
Integrated BeautyLine icon theme (Garuda Linux fork) into the NixOS flake configuration. Provides comprehensive icon coverage with modern gradient-based design.

**Source:** Upstreamed from `worktree-icon-sets`

**Components Added:**

1. **Overlay** (`overlays/beautyline-garuda-overlay.nix`)
   - Packages Garuda fork from GitHub (Tekh-ops/Garuda-Linux-Icons)
   - 5,718 total icons (+485 vs original BeautyLine)
   - 4,148 app icons (+50% vs original)
   - Includes Candy Icons integration
   - Auto-generates icon cache

2. **Home Manager Module** (`home/jf/theme.nix`)
   - GTK configuration with BeautyLine icons
   - Qt configuration (uses GTK theme)
   - Dark theme preference (Adwaita-dark)
   - Cursor theme configuration
   - Fallback icon themes

3. **Flake Integration** (`flake.nix`)
   - Added overlay import to nixpkgs.overlays (line 65)
   - Automatically available as `pkgs.beautyline-garuda`

4. **Home Manager Import** (`home/jf/default.nix`)
   - Added `./theme.nix` to imports (line 26)

5. **Documentation** (`docs/theming/`)
   - `INTEGRATION.md` - Integration guide and status
   - `beautyline-nixos-setup.md` - Full setup documentation
   - `QUICKSTART.md` - Quick reference
   - `ICON_SETS_COMPARISON.md` - Icon count analysis (11 themes)
   - `assets/beautyline-comparison.html` - Visual comparison (36 icons)

**Icon Coverage:**
- Total: 5,718 icons (vs 5,233 original)
- Apps: 4,148 (vs 2,764 original, +50%)
- Actions: 435 (vs 169 original, +157%)
- Mimetypes: 809 (vs 600 original, +35%)
- Devices: 197, Places: 129

**Comparison with Other Themes:**
1. Suru++ - 20,000+ icons (most comprehensive)
2. **BeautyLine Garuda** - 5,718 icons ✅ **Selected**
3. BeautyLine Original - 5,233 icons
4. Papirus - 4,000+ icons
5. Breeze - 3,000 icons
6. Adwaita - 2,000 icons

**Decision Rationale:**
- Excellent gaming/modern app coverage (Garuda Linux gaming focus)
- Beautiful gradient design on dark backgrounds
- Candy Icons integration
- 50% more app icons than original
- Perfect for Steam, Discord, VS Code, development tools

**First Build Requirement:**
```bash
# On first build, nix will show correct sha256 hash
sudo nixos-rebuild switch --flake .#nixos-workstation

# Update overlays/beautyline-garuda-overlay.nix with the hash
# Then rebuild
```

**Visual Preview:**
- Open `docs/theming/assets/beautyline-comparison.html` in browser
- 36 icons compared side-by-side: Original vs Garuda fork
- Black canvas background (#000000)
- Categories: Browsers, Development, Graphics, Multimedia, Office, System, Folders

**Status:** ✅ Integrated, ready for first build

**Next Steps:**
1. ⏳ First build to get SHA256 hash
2. ⏳ Update overlay with correct hash
3. ⏳ Rebuild and verify icons applied
4. ⏳ Test in actual NixOS installation

**Files Modified:**
- `flake.nix` - Added overlay import
- `home/jf/default.nix` - Added theme.nix import

**Files Created:**
- `overlays/beautyline-garuda-overlay.nix`
- `home/jf/theme.nix`
- `docs/theming/INTEGRATION.md`
- `docs/theming/beautyline-nixos-setup.md`
- `docs/theming/QUICKSTART.md`
- `docs/theming/ICON_SETS_COMPARISON.md`
- `docs/theming/assets/beautyline-comparison.html` (433KB, 36 icons embedded)

**Research Data:**
- Icon count analysis across 11 popular themes
- BeautyLine Garuda vs Original detailed comparison
- Visual style analysis and gradients documented
- nixpkgs availability verified (original available, Garuda via overlay)

---

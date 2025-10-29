# NixOS Package Availability Matrix

**Generated:** 2025-10-28
**Total Tools:** 28 (current, non-deprecated only)
**Method:** nixos MCP server + Sourcegraph verification

---

## Summary

| Status | Count | Percentage |
|--------|-------|------------|
| ✅ Available in nixpkgs | 26 | 92.9% |
| ⚠️ Pending (in source, not in channels) | 1 | 3.6% |
| ❌ Missing (need alternative) | 1 | 3.6% |

**Usable now:** 26/28 tools (92.9%)
**Usable after rumdl channel release:** 27/28 tools (96.4%)

---

## Tier 1: Core Development Tools

| Tool | Language(s) | Status | Version | Package Name | Notes |
|------|-------------|--------|---------|--------------|-------|
| **biome** | JS/TS/JSON/CSS/HTML | ✅ nixpkgs | 2.2.2 | biome | Multi-language powerhouse |
| **ruff** | Python | ✅ nixpkgs | 0.12.8 | ruff | 10-100x faster linter+formatter |
| **taplo** | TOML | ✅ nixpkgs | 0.10.0 | taplo | TOML toolkit with LSP |
| **clippy** | Rust | ✅ nixpkgs | 1.89.0 | clippy | Rust linter (part of rustup) |
| **rustfmt** | Rust | ✅ nixpkgs | 1.89.0 | rustfmt | Rust formatter |
| **dprint** | 10+ languages | ✅ nixpkgs | 0.50.1 | dprint | Unified formatter framework |

---

## Tier 2: Language-Specific Tools

| Tool | Language(s) | Status | Version | Package Name | Notes |
|------|-------------|--------|---------|--------------|-------|
| **selene** | Lua | ✅ nixpkgs | 0.29.0 | selene | Blazing fast Lua linter |
| **stylua** | Lua | ✅ nixpkgs | 2.1.0 | stylua | Opinionated Lua formatter |
| **statix** | Nix | ✅ nixpkgs | 0.5.8 | statix | Anti-pattern linter for Nix |
| **deadnix** | Nix | ✅ nixpkgs | 1.3.1 | deadnix | Dead code scanner for Nix |
| **nixfmt** | Nix | ✅ nixpkgs | multiple | nixfmt | Official Nix formatter |
| **alejandra** | Nix | ✅ nixpkgs | 4.0.0 | alejandra | Uncompromising Nix formatter |
| **nixpkgs-fmt** | Nix | ✅ nixpkgs | 1.3.0 | nixpkgs-fmt | Nixpkgs formatter |
| **golangci-lint** | Go | ✅ nixpkgs | 2.4.0 | golangci-lint | Fast Go linters runner |
| **shfmt** | Bash/Shell | ✅ nixpkgs | 3.12.0 | shfmt | Shell script formatter |

---

## Tier 3: Specialized Tools

| Tool | Language(s) | Status | Version | Package Name | Notes |
|------|-------------|--------|---------|--------------|-------|
| **mago** | PHP | ✅ nixpkgs | 0.26.1 | mago | First Rust PHP toolchain |
| **checkmark** | Markdown | ❌ Missing | - | - | AI spell check + link validator |
| **rumdl** | Markdown | ⚠️ Pending | - | rumdl | In nixpkgs source, not in channels yet |

---

## Tier 4: Same-Language Fallback

| Tool | Language(s) | Status | Version | Package Name | Notes |
|------|-------------|--------|---------|--------------|-------|
| **clang-tools** | C/C++ | ✅ nixpkgs | 19.1.7 | clang-tools | Includes clang-format + clang-tidy |
| **cppcheck** | C/C++ | ✅ nixpkgs | 2.18.1 | cppcheck | Static C/C++ analyzer |
| **google-java-format** | Java | ✅ nixpkgs | 1.28.0 | google-java-format | Google's Java formatter |

---

## LSP Servers

| Tool | Language(s) | Status | Version | Package Name | Notes |
|------|-------------|--------|---------|--------------|-------|
| **rust-analyzer** | Rust | ✅ nixpkgs | 2025-08-11 | rust-analyzer | Official Rust LSP |
| **gopls** | Go | ✅ nixpkgs | 0.20.0 | gopls | Official Go LSP |
| **zls** | Zig | ✅ nixpkgs | 0.15.0 | zls | Zig LSP |
| **nixd** | Nix | ✅ nixpkgs | 2.6.4 | nixd | Modern Nix LSP |

---

## Supporting Tools

| Tool | Language(s) | Status | Version | Package Name | Notes |
|------|-------------|--------|---------|--------------|-------|
| **tree-sitter** | Universal | ✅ nixpkgs | 0.25.6 | tree-sitter | Syntax highlighting framework |
| **nushell** | Shell | ✅ nixpkgs | 0.106.1 | nushell | Modern shell with validation |
| **cue** | CUE | ✅ nixpkgs | 0.14.1 | cue | Data validation language |

---

## Missing Tools Analysis

### 1. checkmark (Markdown AI Validator)

**Repository:** github.com/vvvar/checkmark
**Status:** Not in nixpkgs
**Alternatives:**
- Install via cargo: `cargo install checkmark`
- Wait for community overlay
- Skip AI validation (use rumdl only)

**Recommendation:** Install via cargo if AI spell check is critical, otherwise skip.

---

### 2. rumdl (Markdown Linter+Formatter)

**Repository:** github.com/rvben/rumdl
**Status:** ⚠️ In nixpkgs source but not in channels yet

**Investigation results:**
- ✅ **Confirmed in nixpkgs source:** `pkgs/by-name/ru/rumdl/package.nix`
- ❌ **Not available in channels:** unstable/stable queries return NOT_FOUND
- 📍 **Location:** Uses newer `by-name` directory structure

**Analysis:**
Package exists in nixpkgs master branch but hasn't been released to channels yet. This is common for newly added packages.

**Options:**
1. **Wait for next channel update** (recommended) - package will appear in unstable soon
2. **Install from nixpkgs master:**
   ```nix
   rumdl = pkgs.callPackage (pkgs.fetchFromGitHub {
     owner = "NixOS";
     repo = "nixpkgs";
     # Use latest commit hash
   } + "/pkgs/by-name/ru/rumdl/package.nix") {};
   ```
3. **Cargo fallback:** `cargo install rumdl`

**Recommendation:** Check again in 1-2 weeks when channel updates, or use cargo install for immediate availability.

---

## Installation Strategy

### Phase 1: Install from nixpkgs (26 tools)

Add to `configuration.nix`:

```nix
environment.systemPackages = with pkgs; [
  # Tier 1: Core
  biome ruff taplo clippy rustfmt dprint

  # Tier 2: Language-specific
  selene stylua statix deadnix nixfmt alejandra nixpkgs-fmt
  golangci-lint shfmt

  # Tier 3: Specialized
  mago

  # Tier 4: Same-language fallback
  clang-tools cppcheck google-java-format

  # LSP servers
  rust-analyzer gopls zls nixd

  # Supporting tools
  tree-sitter nushell cue
];
```

### Phase 2: Check overlays (2 tools)

Search community overlays for:
- checkmark
- rumdl (if truly missing)

### Phase 3: Cargo fallback (if needed)

```bash
# If overlays don't have them
cargo install checkmark rumdl
```

---

## Next Steps

1. ✅ Complete this availability matrix
2. ✅ Search community overlays for missing tools (none found)
3. ⏳ Update TOOLING_INTEGRATION_GUIDE.md with final installation method
4. ⏳ Decide on checkmark: cargo install or skip AI validation
5. ⏳ Monitor rumdl availability in unstable channel
6. ⏳ Test installation in NixOS flake configuration

---

## Verification Method

**MCP Server:** nixos (mcp-nixos v1.0.0)
**Search queries:** Package names from TOOLING_RESEARCH.md
**Cross-reference:** Sourcegraph search of nixpkgs repository

**Confidence:** High for ✅ tools (verified via MCP)
**Confidence:** Medium for ❌ tools (need overlay investigation)

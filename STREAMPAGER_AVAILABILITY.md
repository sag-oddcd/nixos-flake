# Streampager Availability in NixOS

**Query:** Is `streampager` (also known as `sapling-streampager`) available via nixpkgs or overlays?

**Status:** ✅ **Available via NUR (Nix User Repository)**

---

## Summary

**Streampager** is NOT in official nixpkgs but IS available through:
1. **NUR (Nix User Repository)** - KokaKiwi's packages
2. **Bundled with Sapling VCS** - Available indirectly in official nixpkgs

---

## Official nixpkgs Status

### Direct Package
- **Status:** ❌ NOT available as standalone package
- **Package name:** `streampager` - not found in nixpkgs search
- **Alternative name:** `sapling-streampager` - not found in nixpkgs search

### Bundled with Sapling
- **Status:** ✅ Available as dependency of Sapling VCS
- **Package:** `sapling` (version 0.2.20240718-145624+f4e9df48)
- **Description:** Scalable, User-Friendly Source Control System
- **Homepage:** https://sapling-scm.com
- **License:** GPLv2
- **Evidence:** `streampager` appears in Sapling's `Cargo.lock` file

**Nixpkgs location:**
```
pkgs/by-name/sa/sapling/package.nix
pkgs/by-name/sa/sapling/Cargo.lock (contains streampager dependency)
```

---

## NUR Availability

### KokaKiwi's NUR Package

**Repository:** https://github.com/KokaKiwi/nur-packages

**Package definition:**
```nix
{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:
rustPlatform.buildRustPackage rec {
  pname = "streampager";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "markbt";
    repo = "streampager";
    rev = "v${version}";
    hash = "sha256-xOFm/tjZBkkUa/Q5SStZSX++oTgd+ncY47dg5Ryvjo4=";
  };

  cargoHash = "sha256-rUSyMzCro2VY10zmJembE80o9MaG+uqx21zzfUnxNAQ=";

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreFoundation
    CoreServices
  ]);

  meta = with lib; {
    description = "A pager for command output or large files";
    homepage = "https://github.com/markbt/streampager";
    license = licenses.mit;
    mainProgram = "streampager";
  };
}
```

**NUR path:**
```
nix-community/nur-combined/repos/kokakiwi/pkgs/applications/streampager/
```

---

## Upstream Information

**Project:** markbt/streampager
**URL:** https://github.com/markbt/streampager
**Description:** A pager for command output or large files
**License:** MIT
**Language:** Rust

**Latest upstream activity:**
- Created: 2019-06-02
- Last update: 2025-10-27
- Last push: 2023-03-12

**Main programs:**
- `sp` - Pager for stdin or files
- `spp` - Wrapper to run commands and page their output

**Features:**
- Stream paging with fullscreen mode
- Multiple input streams on separate screens
- Error stream display (last 8 lines shown at bottom)
- Progress indicator support
- Configurable keybindings (similar to `less`)
- Line wrapping and line numbers

---

## Usage in NixOS Configuration

### Option 1: Use NUR (Standalone streampager)

**Add NUR to your flake:**

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nur, ... }: {
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        { nixpkgs.overlays = [ nur.overlay ]; }
      ];
    };
  };
}
```

**In configuration.nix:**

```nix
{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.nur.repos.kokakiwi.streampager
  ];
}
```

### Option 2: Install Sapling VCS (Includes streampager)

**In configuration.nix:**

```nix
{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.sapling  # streampager is bundled as dependency
  ];
}
```

**Note:** Sapling includes streampager in its Cargo dependencies, but it may not expose the standalone `sp` binary. If you need the standalone pager, use NUR.

### Option 3: Custom Package Definition (Copy from NUR)

**Create `pkgs/streampager.nix` in your config:**

```nix
{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "streampager";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "markbt";
    repo = "streampager";
    rev = "v${version}";
    hash = "sha256-xOFm/tjZBkkUa/Q5SStZSX++oTgd+ncY47dg5Ryvjo4=";
  };

  cargoHash = "sha256-rUSyMzCro2VY10zmJembE80o9MaG+uqx21zzfUnxNAQ=";

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreFoundation
    CoreServices
  ]);

  meta = with lib; {
    description = "A pager for command output or large files";
    homepage = "https://github.com/markbt/streampager";
    license = licenses.mit;
    mainProgram = "streampager";
  };
}
```

**Import in configuration.nix:**

```nix
{ config, pkgs, ... }:
let
  streampager = pkgs.callPackage ./pkgs/streampager.nix {};
in
{
  environment.systemPackages = [
    streampager
  ];
}
```

---

## Recommendations

### For Your NixOS Migration

Based on your context:
- You mentioned "sapling-streampager" in relation to pager setup
- Your previous session noted replacing earlier pager configurations

**Recommended approach:**

1. **If you need standalone streampager:**
   - Use NUR (Option 1) - cleanest and maintained by community
   - Version: 0.10.3 (relatively recent)

2. **If you're using Sapling VCS anyway:**
   - Install `pkgs.sapling` - gets streampager as dependency
   - Sapling is actively maintained in nixpkgs

3. **If you want full control:**
   - Copy package definition (Option 3) into your flake
   - Allows version pinning and customization

### Integration with Your Flake

For `worktree-flake` development:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    lanzaboote = { /* ... */ };
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, lanzaboote, nur, ... }: {
    nixosConfigurations.pc-black-screen = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        lanzaboote.nixosModules.lanzaboote
        { nixpkgs.overlays = [ nur.overlay ]; }
      ];
    };
  };
}
```

```nix
# configuration.nix
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # ... other packages ...
    nur.repos.kokakiwi.streampager  # Standalone pager
    # OR
    sapling  # VCS with bundled streampager
  ];

  # Optional: Set as default pager
  environment.variables = {
    PAGER = "${pkgs.nur.repos.kokakiwi.streampager}/bin/sp";
  };
}
```

---

## Relationship to Sapling

**Sapling VCS** (Facebook/Meta project):
- Modern source control system (Mercurial fork)
- Uses streampager as dependency for paging output
- Available in official nixpkgs: `pkgs.sapling`
- Version: 0.2.20240718-145624+f4e9df48

**Streampager connection:**
- Originally developed independently by Mark Thomas (markbt)
- Adopted by Facebook/Meta for Sapling VCS
- Listed in Sapling's Cargo.lock as dependency
- Not the same as "sapling-streampager" (no such separate package exists)

**Clarification:**
- "sapling-streampager" appears to be a conflation of:
  - `sapling` (the VCS tool)
  - `streampager` (the pager it uses)
- There is NO package named "sapling-streampager" in nixpkgs or NUR

---

## Conclusion

✅ **Streampager is available for NixOS via NUR**

**Recommended installation method:**
- **NUR (KokaKiwi's repository)** - provides standalone `streampager` v0.10.3
- Actively maintained, MIT licensed, Rust-based

**Alternative:**
- Install `sapling` from official nixpkgs if you need the VCS tool (streampager comes bundled)

**Status for your migration:**
- You can safely use streampager in your NixOS configuration
- Add NUR to your flake inputs
- Reference `pkgs.nur.repos.kokakiwi.streampager` in your packages list

---

**Documentation Date:** 2025-10-28
**Research Completed:** Session in `worktree-flake`
**Related Files:** `configuration.nix`, `flake.nix` (pending creation)

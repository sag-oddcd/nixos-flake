# MCP-NixOS Troubleshooting Guide

## Issue Summary

**Error:** "Failed to reconnect to nixos" in Claude Code
**Root Cause:** FastMCP dependency `py-key-value-aio[memory]` not installed correctly in Android/Termux proot environment

## Official Repository

**GitHub:** https://github.com/utensils/mcp-nixos
**Latest Version:** v1.0.3 (2025-10-18)
**PyPI:** https://pypi.org/project/mcp-nixos/

## Environment Issues Identified

### 1. Hardlink Filesystem Limitation (SOLVED)

**Problem:** Android proot doesn't support hardlinks
```
error: failed to hardlink file: Operation not permitted (os error 1)
```

**Solution:** Configure UV to use copy mode
```bash
mkdir -p ~/.config/uv
cat > ~/.config/uv/uv.toml << 'EOF'
# UV Configuration for Android/Termux proot environment
link-mode = "copy"
EOF
```

**Status:** ✅ FIXED - Installation now proceeds past this error

### 2. Missing Dependency Extra (CURRENT ISSUE)

**Problem:** FastMCP requires `py-key-value-aio[memory]` but uvx doesn't install extras from transitive dependencies
```
ImportError: cannot import name 'TLRUCache' from 'cachetools' (unknown location)
ImportError: MemoryStore requires py-key-value-aio[memory]
```

**Root Cause:**
- `mcp-nixos` depends on `fastmcp>=2.11.0`
- `fastmcp` internally requires `py-key-value-aio[memory]` (for cachetools with TLRUCache)
- `uvx` doesn't resolve optional extras from indirect dependencies

## Solutions (3 Options)

### Option A: Install with Full Dependencies (RECOMMENDED)

Install mcp-nixos with pip/uv into Claude's isolated Python environment:

```bash
# Using uv (recommended)
/home/jf/.claude/runtime/python/bin/uv pip install mcp-nixos 'py-key-value-aio[memory]'

# Verify installation
/home/jf/.claude/runtime/python/bin/python -m mcp_nixos.server --help
```

Then update `~/.mcp.json`:
```json
{
  "mcpServers": {
    "nixos": {
      "command": "/home/jf/.claude/runtime/python/bin/python",
      "args": ["-m", "mcp_nixos.server"]
    }
  }
}
```

**Advantages:**
- ✅ Uses isolated Claude Python runtime (no system contamination)
- ✅ Explicit dependency installation (no surprises)
- ✅ Faster startup (no uvx overhead)
- ✅ Follows user's MCP installation policy (isolated runtimes)

### Option B: Use Nix Runtime (If Available)

If Nix is available on this system (unlikely in Android proot):

```json
{
  "mcpServers": {
    "nixos": {
      "command": "nix",
      "args": ["run", "github:utensils/mcp-nixos", "--"]
    }
  }
}
```

**Status:** ⚠️ Requires Nix installation (not applicable here)

### Option C: Use Docker (Not Applicable)

The repository provides Docker images, but Docker isn't available in Android proot:

```bash
docker pull ghcr.io/utensils/mcp-nixos:1.0.3
```

**Status:** ❌ Docker not available in Termux proot

## Implementation Steps (Option A)

### Step 1: Install Dependencies

```bash
/home/jf/.claude/runtime/python/bin/uv pip install mcp-nixos 'py-key-value-aio[memory]'
```

### Step 2: Verify Installation

```bash
# Test direct Python module execution
/home/jf/.claude/runtime/python/bin/python -m mcp_nixos.server --help

# Should show FastMCP server help or start without errors
```

### Step 3: Update MCP Configuration

```bash
# Backup current config
cp ~/.mcp.json ~/.mcp.json.backup

# Update nixos server configuration
# (Show user the config change, let them edit manually or provide command)
```

New configuration in `~/.mcp.json`:
```json
{
  "mcpServers": {
    "nixos": {
      "command": "/home/jf/.claude/runtime/python/bin/python",
      "args": ["-m", "mcp_nixos.server"]
    }
  }
}
```

### Step 4: Restart Claude Code

After updating the configuration, restart the Claude Code session to reconnect to the MCP server.

## Available Tools (Once Working)

### NixOS Tools
- `nixos_search(query, type, channel)` - Search packages, options, or programs
- `nixos_info(name, type, channel)` - Get detailed info about packages/options
- `nixos_stats(channel)` - Package and option counts
- `nixos_channels()` - List all available channels
- `nixos_flakes_search(query)` - Search community flakes
- `nixos_flakes_stats()` - Flake ecosystem statistics

### Version History Tools (via NixHub.io)
- `nixhub_package_versions(package, limit)` - Get version history with commit hashes
- `nixhub_find_version(package, version)` - Smart search for specific versions

### Home Manager Tools
- `home_manager_search(query)` - Search user config options
- `home_manager_info(name)` - Get option details with suggestions
- `home_manager_stats()` - See what's available
- `home_manager_list_options()` - Browse all 131 categories
- `home_manager_options_by_prefix(prefix)` - Explore options by prefix

### Darwin Tools (macOS)
- `darwin_search(query)` - Search macOS options
- `darwin_info(name)` - Get option details
- `darwin_stats()` - macOS configuration statistics
- `darwin_list_options()` - Browse all 21 categories
- `darwin_options_by_prefix(prefix)` - Explore macOS options

## Key Features

- **No Nix/NixOS Required:** Works on any system (Windows, macOS, Linux, Android)
- **Real-time Data:** Queries web APIs for current information
- **130K+ Packages:** Complete NixOS package repository
- **22K+ Options:** NixOS configuration options
- **4K+ Home Manager Settings:** User environment configurations
- **Version History:** Find package versions with commit hashes via NixHub.io

## References

- **Repository:** https://github.com/utensils/mcp-nixos
- **Issues:** https://github.com/utensils/mcp-nixos/issues
- **PyPI:** https://pypi.org/project/mcp-nixos/
- **Docker Hub:** https://hub.docker.com/r/utensils/mcp-nixos
- **GHCR:** https://github.com/utensils/mcp-nixos/pkgs/container/mcp-nixos

## Environment Details

- **Python Version:** 3.13.5 (Claude isolated runtime)
- **UV Version:** 0.9.3
- **Platform:** Debian proot (Android/Termux)
- **Filesystem Limitation:** No hardlink support (fixed with UV config)
- **MCP Config:** `~/.mcp.json`
- **UV Config:** `~/.config/uv/uv.toml`

## Status

- [x] Repository identified
- [x] Hardlink issue resolved (UV config)
- [x] Dependency installation complete (Option A)
- [x] UV copy mode bug discovered (missing __init__.py files)
- [x] Workaround applied (manual __init__.py download)
- [x] MCP configuration updated
- [x] Server tested and working
- [ ] Connection test pending (requires Claude Code restart)

## CRITICAL BUG DISCOVERED: UV Copy Mode

**Issue:** When using `link-mode = "copy"` in UV config, some packages install incompletely:
- `cachetools-6.2.1` installed without `__init__.py` file
- Causes `ImportError: cannot import name 'X' from 'module' (unknown location)`
- Affects other packages that may be missing critical files

**Workaround Applied:**
```bash
# Manually downloaded missing __init__.py
curl -s "https://raw.githubusercontent.com/tkem/cachetools/master/src/cachetools/__init__.py" \
  -o /home/jf/.claude/runtime/python/lib/python3.13/site-packages/cachetools/__init__.py
```

**Long-term Solution Needed:**
- Report bug to UV developers
- Consider alternative installation methods for proot environments
- Monitor for UV updates that fix copy mode
- May need to manually verify package integrity after installations

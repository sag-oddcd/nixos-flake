# Project: Tooling Research (NixOS Migration)

## Primary Research Sources

When searching for language tooling solutions (linters, formatters, type checkers, LSP servers), always consult these primary sources:

### 1. Linters/Formatters/Type Checkers as Plugins

#### dprint Plugin Catalog
- **URL:** https://plugins.dprint.dev/
- **Description:** Official plugin directory
- **Coverage:** TypeScript, JSON, Markdown, TOML, Dockerfile, Biome, Ruff, Jupyter, and community plugins
- **Format:** WASM and process plugins

#### Biome Plugin Ecosystem
- **Status:** No plugin/extension directory exists
- **Architecture:** Monolithic toolchain without traditional plugin support
- **Note:** Functionality built into core binary

### 2. CLI Tools (Rust, Go, Zig)

#### Rust CLI Catalogs
- https://github.com/rust-unofficial/awesome-rust
- https://lib.rs/command-line-utilities
- https://github.com/unpluggedcoder/awesome-rust-tools
- https://github.com/matu3ba/awesome-cli-rust
- https://github.com/pa-0/AWESOME-rust-cli

#### Go CLI Catalogs
- https://github.com/avelino/awesome-go (main catalog, see Command Line section)
- https://awesome-go.com/standard-cli/
- https://github.com/mantcz/awesome-go-cli
- https://github.com/gobuild/awesome-go-tools

#### Zig CLI Catalogs
- https://github.com/zigcc/awesome-zig
- https://zigistry.dev/ (Zig package registry)
- **Notable frameworks:** zig-cli, zig-clap, yazap, cova, zli

### 3. LSP Solutions

#### LSP Server Directories
- **https://langserver.org/** - Community-driven, comprehensive list with capability matrices
- **https://github.com/microsoft/language-server-protocol** - Official Microsoft list in implementors section
- **https://wiki.archlinux.org/title/Language_Server_Protocol** - Arch Linux curated list

### Additional Sources
- GitHub trending (Rust/Go projects)
- crates.io registry
- Web search for recent releases (2024-2025)
- Official language documentation

**Catalog Verification Date:** 2025-10-27

## Project Context

This worktree is dedicated to researching development tooling for the NixOS migration project, focusing on:
- Rust/Go/Zig-based tools only
- LSP compatibility
- Active maintenance (2024-2025)
- Coverage across 24+ programming languages

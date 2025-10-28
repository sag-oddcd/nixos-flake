# Language Tooling Integration Guide for NixOS Flake

**Research Date:** 2025-10-28
**Source:** worktree-tooling-research (parallel worker analysis)

---

## 📁 Research Documents Included

### 1. **TOOLING_RESEARCH.md** (Main Document)
Comprehensive analysis of linters, formatters, and syntax highlighters for 25 programming languages.

**Coverage:**
- ✅ 18 languages with Rust/Go/Zig tools (72%)
- ✅ 6 languages with same-language fallback (24%)
- ✅ 1 language with Haskell (Bash/shellcheck) (4%)
- ✅ 100% total coverage

**Key Tools Discovered:**
- **Biome** (Rust) - Multi-language champion: JS/TS/JSON/CSS/HTML
- **mago** (Rust) - PHP linter + formatter (breakthrough)
- **selene** (Rust) - Lua linter (confirmed)
- **6 Markdown linters** (Rust) - mado, rumdl, quickmark, checkmark, mdlinker, mdcheck
- **ruff** (Rust) - Python unified linter + formatter

---

### 2. **TOOLING_PRIMARY_SOURCES.md**
Catalog directories and registries to find language tooling solutions.

**Categories:**
1. **Linters/Formatters as Plugins**
   - dprint plugin catalog
   - Biome ecosystem info

2. **CLI Tools (Rust, Go, Zig)**
   - 5 Rust CLI catalogs
   - 4 Go CLI catalogs
   - 2 Zig catalogs

3. **LSP Solutions**
   - langserver.org
   - Microsoft LSP implementors
   - Arch Linux LSP wiki

---

### 3. **LSP_SERVER_CATALOG.md** (Comprehensive 90+ pages)
Complete LSP server analysis with implementation languages, installation methods, and maintenance status.

**Key Findings:**
- 7 Rust/Go/Zig LSP servers (28%)
- 16 TypeScript/Node.js LSP servers (64%)
- 2 Experimental Rust LSP servers (8%)

**Production-Ready Rust/Go/Zig LSP:**
- TOML → taplo-lsp (Rust)
- Nix → rnix-lsp (Rust)
- CUE → cuepls (Go)
- Nushell → nu-lsp (Rust, built-in)
- Rust → rust-analyzer (Rust)
- Go → gopls (Go)
- Zig → zls (Zig)

---

## 🎯 Integration Strategy for NixOS Flake

### Rust-First Tooling Stack:

**Formatters:**
```nix
environment.systemPackages = with pkgs; [
  # dprint - unified formatter framework
  dprint

  # Biome - multi-language (JS/TS/JSON/CSS/HTML)
  biome

  # Language-specific
  taplo       # TOML
  stylua      # Lua
  rustfmt     # Rust (via rustup)
  nixpkgs-fmt # Nix alternative
  alejandra   # Nix alternative
];
```

**Linters:**
```nix
environment.systemPackages = with pkgs; [
  # Multi-language
  biome       # JS/TS/JSON/CSS/HTML

  # Language-specific
  clippy      # Rust (via rustup)
  oxlint      # JS/TS alternative
  ruff        # Python
  taplo       # TOML
  selene      # Lua
  statix      # Nix
  deadnix     # Nix

  # Markdown (choose one or multiple)
  # rumdl     # Most actively maintained (linter + formatter)
  # mado      # Pure linter
  # quickmark # With LSP support
];
```

**Go-Based Tools:**
```nix
environment.systemPackages = with pkgs; [
  golangci-lint  # Go meta-linter
  shfmt          # Shell formatter
  # go-mdfmt     # Markdown formatter (optional)
];
```

**LSP Servers (Rust/Go/Zig):**
```nix
environment.systemPackages = with pkgs; [
  # Rust LSP servers
  taplo-lsp      # TOML
  rnix-lsp       # Nix (or nixd)
  rust-analyzer  # Rust

  # Go LSP servers
  gopls          # Go
  # cuepls       # CUE (if needed)

  # Built-in LSP
  nushell        # Includes nu-lsp (nu --lsp)
];
```

**TypeScript/Node.js LSP Servers (via isolated pnpm):**
```nix
# Use $CLAUDE_PNPM_BIN for isolated installation
# bash-language-server
# yaml-language-server
# typescript-language-server
# vscode-langservers-extracted (CSS/HTML/JSON)
```

---

### Same-Language Fallback Tools:

**Java:**
```nix
environment.systemPackages = with pkgs; [
  google-java-format  # Formatter
  # SpotBugs via IDE plugins
  # PMD via IDE plugins
];
```

**Kotlin:**
```nix
# Use ktlint and detekt via Gradle/Maven
# Or install via system packages if available
```

**C/C++:**
```nix
environment.systemPackages = with pkgs; [
  clang-tools  # Includes clang-format, clang-tidy
  cppcheck     # Additional linter
];
```

**PowerShell:**
```nix
# PSScriptAnalyzer available via PowerShell Gallery
# pwsh -Command "Install-Module -Name PSScriptAnalyzer"
```

**C#:**
```nix
environment.systemPackages = with pkgs; [
  dotnetCorePackages.sdk  # Includes dotnet format
  # OmniSharp via editor plugins
];
```

**Julia:**
```nix
# Install via Julia package manager
# using Pkg
# Pkg.add("JuliaFormatter")
# Pkg.add("StaticLint")
```

---

## 📊 Quick Reference Matrix

| Language | Linter | Formatter | Implementation |
|----------|--------|-----------|----------------|
| CSS | Biome | malva, Biome | Rust |
| HTML | Biome | markup_fmt, Biome | Rust |
| Markdown | mado, rumdl, quickmark... | dprint, rumdl | Rust |
| TypeScript/JS | Biome, oxlint | Biome, dprint | Rust |
| PHP | mago | mago | Rust |
| Lua | selene | stylua | Rust |
| Python | ruff | ruff | Rust |
| Nix | statix, deadnix | nixfmt, alejandra | Rust |
| Rust | clippy | rustfmt | Rust |
| Go | golangci-lint | gofmt, gofumpt | Go |
| CUE | cue vet | cue fmt | Go |
| Bash | shellcheck | shfmt | Haskell/Go |
| Java | SpotBugs, PMD | google-java-format | Java |
| Kotlin | ktlint, detekt | ktlint, ktfmt | Kotlin |
| C/C++ | clang-tidy, cppcheck | clang-format | C++ |
| C# | Roslyn analyzers | dotnet format | C# |
| PowerShell | PSScriptAnalyzer | PSScriptAnalyzer | PowerShell/C# |
| Julia | StaticLint.jl | JuliaFormatter.jl | Julia |

---

## 🔧 Installation Priority

**Tier 1 (Essential - Rust/Go):**
1. Biome (multi-language powerhouse)
2. ruff (Python)
3. taplo (TOML)
4. clippy + rustfmt (Rust)
5. dprint (formatter framework)

**Tier 2 (Language-Specific):**
6. selene + stylua (Lua)
7. statix + deadnix + nixfmt (Nix)
8. golangci-lint + gofmt (Go)
9. shfmt (Bash)

**Tier 3 (Optional/Specialized):**
10. mago (PHP)
11. rumdl (Markdown)
12. oxlint (JS/TS alternative)

**Tier 4 (Same-Language Fallback - as needed):**
13. clang-format + clang-tidy (C/C++)
14. google-java-format (Java)
15. dotnet format (C#)

---

## 📝 Integration Notes

1. **Rust tools via cargo**: Install via `cargo install` or Nix packages
2. **Go tools via go install**: Use `go install` or Nix packages
3. **LSP servers**: Mix Rust/Go/Zig + TypeScript/Node.js for full coverage
4. **Isolated Node.js**: Use `$CLAUDE_PNPM_BIN` for TypeScript LSP servers
5. **tree-sitter**: Universal syntax highlighting for all 25 languages

---

## 🚀 Next Steps

1. Review TOOLING_RESEARCH.md for detailed tool information
2. Consult LSP_SERVER_CATALOG.md for LSP server setup
3. Check TOOLING_PRIMARY_SOURCES.md for discovery catalogs
4. Integrate selected tools into NixOS flake configuration
5. Test tooling with code-validating skill (supports 21 languages)

---

**Generated:** 2025-10-28
**Research Scope:** 25 languages, 3 parallel workers, 100% coverage achieved

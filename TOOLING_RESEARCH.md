# Language Tooling Research
*Implementation: Rust > Go > Zig only*
*LSP compatible | Actively maintained (2024-2025)*

**Research Date:** 2025-10-28
**Scope:** Development tools (linters, formatters, syntax highlighters, LSP servers) implemented in Rust, Go, or Zig
**Note:** Type checking via custom CUE schemas (not tracked here)

---

## CSS
- **Linter:** Biome (Rust) - multi-language linter
- **Formatter:** malva (Rust) - GitHub: g-plane/malva, via dprint plugin; Biome (Rust)
- **Syntax highlighter:** tree-sitter-css (Rust)

**Notes:**
- Biome supports CSS linting as part of its multi-language toolchain (Oct 2025)
- malva actively maintained (2024), supports CSS, SCSS, Sass, and Less

---

## TOML
- **Linter:** taplo (Rust) - includes schema validation
- **Formatter:** taplo (Rust), dprint-plugin-toml (Rust via dprint)
- **Syntax highlighter:** tree-sitter-toml (Rust)

**Notes:** Taplo is the de-facto standard, includes LSP server (taplo-lsp). Last updated May 2025. Actively maintained.

---

## YAML
- **Linter:** NONE (no Rust/Go/Zig tool found - yamllint is Python)
- **Formatter:** pretty_yaml (Rust) - GitHub: g-plane/pretty_yaml, via dprint plugin
- **Syntax highlighter:** tree-sitter-yaml (Rust)

**Notes:** pretty_yaml is semi-tolerant and configurable, actively maintained (2024).

---

## JSON
- **Linter:** Biome (Rust) - unified linter/formatter
- **Formatter:** Biome (Rust), dprint-plugin-json (Rust via dprint)
- **Syntax highlighter:** tree-sitter-json (Rust)

**Notes:** Biome is 10-100x faster than ESLint/Prettier. Active development (Oct 2025 release).

---

## HTML
- **Linter:** Biome (Rust) - multi-language linter
- **Formatter:** markup_fmt (Rust) - GitHub: g-plane/markup_fmt, via dprint plugin; Biome (Rust)
- **Syntax highlighter:** tree-sitter-html (Rust)

**Notes:**
- Biome supports HTML linting as part of its multi-language toolchain (Oct 2025)
- markup_fmt supports HTML, Vue, Svelte, Astro, Angular, Jinja, Twig, Nunjucks, Vento, Mustache, and XML

---

## Markdown
- **Linter:** mado (Rust), rumdl (Rust), quickmark (Rust), checkmark (Rust), mdlinker (Rust), mdcheck (Rust)
- **Formatter:** dprint-plugin-markdown (Rust via dprint), rumdl (Rust)
- **Syntax highlighter:** tree-sitter-markdown (Rust)

**Notes:**
- **mado:** Markdown linter, last commit Sept 2025
- **rumdl:** Markdown linter & formatter, last commit Oct 2025 (most actively maintained)
- **quickmark:** Markdown linter with LSP support, last commit Sept 2025
- **checkmark:** AI-powered linter with spell check and link validation, last commit Jan 2025
- **mdlinker:** Wikilinks linter, last commit Aug 2025
- **mdcheck:** CommonMark linter, created Oct 2025 (newest)
- dprint-plugin-markdown is widely used for formatting

---

## TypeScript
- **Linter:** Biome (Rust), oxlint (Rust) - 50-100x faster than ESLint
- **Formatter:** Biome (Rust), dprint-plugin-typescript (Rust via dprint)
- **Syntax highlighter:** tree-sitter-typescript (Rust)

**Notes:**
- Biome: 97% compatibility with Prettier, supports TS/JS/JSX/TSX
- oxlint: v1.0 stable (June 2025), 520+ rules, type-aware linting support (Aug 2025)

---

## JavaScript
- **Linter:** Biome (Rust), oxlint (Rust)
- **Formatter:** Biome (Rust), dprint-plugin-typescript (Rust via dprint, works with JS too)
- **Syntax highlighter:** tree-sitter-javascript (Rust)

**Notes:** Same tooling as TypeScript. Biome and oxlint are the modern Rust replacements for ESLint/Prettier.

---

## PHP
- **Linter:** mago (Rust) - comprehensive PHP toolchain
- **Formatter:** mago (Rust)
- **Syntax highlighter:** tree-sitter-php (Rust)

**Notes:** mago is a Rust-based PHP linter & formatter toolchain (GitHub: carthage-software/mago). Last commit Oct 2025, actively maintained.

---

## Lua
- **Linter:** selene (Rust) - GitHub: Kampfkarren/selene
- **Formatter:** stylua (Rust) - GitHub: JohnnyMorganz/StyLua
- **Syntax highlighter:** tree-sitter-lua (Rust)

**Notes:**
- selene: Lua linter, last commit July 2025, actively maintained
- StyLua: Standard Lua formatter, inspired by prettier. Supports Lua 5.1-5.4, LuaJIT, Luau. Last release Sept 2025.

---

## Java
- **Linter:** NONE (no Rust/Go/Zig tool - SpotBugs/PMD are Java-based)
- **Formatter:** NONE (google-java-format is Java-based)
- **Syntax highlighter:** tree-sitter-java (Rust)

**Notes:** Java tooling ecosystem is entirely Java-based. No Rust/Go/Zig alternatives found.

---

## Python
- **Linter:** ruff (Rust) - 10-100x faster than flake8
- **Formatter:** ruff (Rust) - unified linter + formatter
- **Syntax highlighter:** tree-sitter-python (Rust)

**Notes:** Ruff is the modern standard, written in Rust. Replaces flake8, black, isort, etc. Active development (2025).

---

## Kotlin
- **Linter:** NONE (ktlint is Kotlin-based, detekt is Kotlin-based)
- **Formatter:** NONE (ktlint/ktfmt are Kotlin-based)
- **Syntax highlighter:** tree-sitter-kotlin (Rust)

**Notes:** Kotlin tooling is Kotlin-native. ktlint and detekt are the standards but not Rust/Go/Zig.

---

## Nix
- **Linter:** statix (Rust), deadnix (Rust)
- **Formatter:** nixfmt (Rust), nixpkgs-fmt (Rust), alejandra (Rust)
- **Syntax highlighter:** tree-sitter-nix (Rust)

**Notes:**
- nixfmt: Official formatter, now nixfmt-rfc-style (2024)
- nixpkgs-fmt: Community formatter (2024)
- alejandra: Fast formatter (2024)
- statix: Linter for anti-patterns
- deadnix: Detects dead code

---

## CUE
- **Linter:** cue vet (Go) - part of official CUE CLI
- **Formatter:** cue fmt (Go) - part of official CUE CLI
- **Syntax highlighter:** tree-sitter-cue (Rust)

**Notes:** CUE is written in Go, all official tooling is Go-based. cue fmt is the standard formatter, cue vet provides validation.

---

## Fish Shell
- **Linter:** NONE (no dedicated linter - fish -n for syntax check is built into fish shell)
- **Formatter:** fish_indent (C++) - built into fish shell, NOT Rust/Go/Zig
- **Syntax highlighter:** tree-sitter-fish (Rust)

**Notes:** Fish tooling is built into the fish shell itself (written in C++/Rust hybrid). No standalone Rust/Go/Zig tools.

---

## Bash
- **Linter:** shellcheck (Haskell) - NOT Rust/Go/Zig
- **Formatter:** shfmt (Go) - GitHub: mvdan/sh
- **Syntax highlighter:** tree-sitter-bash (Rust)

**Notes:**
- shellcheck is the standard linter (written in Haskell, not Rust/Go/Zig)
- shfmt is written in Go, actively maintained (2024-2025)

---

## PowerShell
- **Linter:** NONE (PSScriptAnalyzer is PowerShell/C#-based)
- **Formatter:** NONE (PSScriptAnalyzer Invoke-Formatter is PowerShell-based)
- **Syntax highlighter:** tree-sitter-powershell (Rust)

**Notes:** PowerShell ecosystem relies on PSScriptAnalyzer (official Microsoft tool). No Rust/Go/Zig alternatives.

---

## Nushell
- **Linter:** NONE (no dedicated linter found)
- **Formatter:** nufmt (Rust) - GitHub: nushell/nufmt
- **Syntax highlighter:** tree-sitter-nu (Rust)

**Notes:** Nushell itself is written in Rust. nufmt is the official formatter (early development).

---

## WASM (WebAssembly Text Format)
- **Linter:** NONE (no dedicated linter found)
- **Formatter:** wat2wasm (C++) - part of WebAssembly Binary Toolkit (wabt)
- **Syntax highlighter:** tree-sitter-wasm (Rust)

**Notes:** WebAssembly tooling (wabt) is written in C++, not Rust/Go/Zig. wat2wasm is a compiler, not formatter.

---

## C#
- **Linter:** NONE (Roslyn analyzers are C#-based)
- **Formatter:** NONE (dotnet format is C#-based, csharpier is C#-based)
- **Syntax highlighter:** tree-sitter-c-sharp (Rust)

**Notes:** C# ecosystem is entirely .NET-based. No Rust/Go/Zig alternatives found.

---

## C/C++
- **Linter:** NONE (clang-tidy is C++, cppcheck is C++)
- **Formatter:** NONE (clang-format is C++, uncrustify is C)
- **Syntax highlighter:** tree-sitter-c (Rust), tree-sitter-cpp (Rust)

**Notes:** C/C++ ecosystem relies on LLVM/Clang-based tools (C++) and legacy C tools. No Rust/Go/Zig alternatives found.

---

## Julia
- **Linter:** NONE (StaticLint.jl/Lint.jl are Julia-based)
- **Formatter:** NONE (JuliaFormatter.jl is Julia-based)
- **Syntax highlighter:** tree-sitter-julia (Rust)

**Notes:** Julia tooling is Julia-native. JuliaFormatter.jl is the standard (inspired by gofmt/prettier).

---

## Rust
- **Linter:** clippy (Rust) - official linter, 750+ rules
- **Formatter:** rustfmt (Rust) - official formatter
- **Syntax highlighter:** tree-sitter-rust (Rust)

**Notes:** Rust has first-class tooling built into the language. Both clippy and rustfmt are official tools.

---

## Go
- **Linter:** golangci-lint (Go) - aggregates multiple linters
- **Formatter:** gofmt (Go) - official formatter, gofumpt (Go) for stricter formatting
- **Syntax highlighter:** tree-sitter-go (Rust)

**Notes:** Go has built-in tooling. gofmt is canonical, golangci-lint is the standard meta-linter.

---

# LSP Server Catalog

## LSP Servers Implemented in Rust/Go/Zig

### Production-Ready (7 languages):

| Language | LSP Server | Implementation | Status | Repository |
|----------|-----------|---------------|--------|------------|
| **TOML** | taplo-lsp | Rust | ✅ Active | https://github.com/tamasfe/taplo |
| **Nix** | rnix-lsp | Rust | ✅ Active | https://github.com/nix-community/rnix-lsp |
| **CUE** | cuepls | Go | ✅ Active | https://github.com/cue-lang/cue |
| **Nushell** | nu-lsp | Rust (built-in) | ✅ Active | https://github.com/nushell/nushell |
| **Rust** | rust-analyzer | Rust | ✅ Active | https://github.com/rust-lang/rust-analyzer |
| **Go** | gopls | Go | ✅ Active | https://github.com/golang/tools/tree/master/gopls |
| **Zig** | zls | Zig | ✅ Active | https://github.com/zigtools/zls |

### Experimental/Unstable (2 languages):

| Language | LSP Server | Implementation | Status | Repository |
|----------|-----------|---------------|--------|------------|
| **Markdown** | prosemd / Markmark | Rust | ⚠️ Experimental | Various repos |
| **WASM** | wasm-lsp | Rust | ⚠️ Early dev | https://github.com/wasm-lsp/wasm-lsp-server |

### No Rust/Go/Zig LSP Available (16 languages):

These languages only have TypeScript/Node.js or native language LSP implementations:

- **CSS** - vscode-css-languageserver (TypeScript)
- **YAML** - yaml-language-server (TypeScript)
- **JSON** - vscode-json-languageserver (TypeScript)
- **HTML** - vscode-html-languageserver (TypeScript)
- **TypeScript/JavaScript** - typescript-language-server (TypeScript)
- **PHP** - intelephense/phpactor (Proprietary/PHP)
- **Lua** - lua-language-server (Lua)
- **Java** - jdtls (Java)
- **Python** - pyright/pylsp (TypeScript/Python)
- **Kotlin** - kotlin-language-server (Kotlin)
- **Fish** - fish-lsp (TypeScript)
- **Bash** - bash-language-server (TypeScript)
- **PowerShell** - PowerShellEditorServices (C#)
- **C#** - csharp-ls/OmniSharp (C#)
- **C/C++** - clangd (C++)
- **Julia** - LanguageServer.jl (Julia)

### Key Findings:

1. **Rust/Go/Zig LSP coverage: 7/25 languages (28%)**
2. **TypeScript/Node.js dominates**: 16 languages require Node.js LSP servers
3. **Hybrid approach required**: Cannot avoid TypeScript/Node.js for comprehensive LSP support
4. **Rust LSP framework**: tower-lsp enables rapid Rust LSP development
5. **Nushell integration**: LSP built directly into shell (`nu --lsp`)

### Installation Examples:

**Rust LSP servers:**
```bash
# taplo-lsp (TOML)
cargo install taplo-cli --features lsp

# rnix-lsp (Nix)
cargo install rnix-lsp

# rust-analyzer (Rust)
rustup component add rust-analyzer
```

**Go LSP servers:**
```bash
# gopls (Go)
go install golang.org/x/tools/gopls@latest

# cuepls (CUE)
go install cuelang.org/go/cmd/cuepls@latest
```

**TypeScript LSP servers (via isolated Claude Code runtime):**
```bash
# Using Claude Code's isolated pnpm
$CLAUDE_PNPM_BIN dlx bash-language-server
$CLAUDE_PNPM_BIN dlx yaml-language-server
$CLAUDE_PNPM_BIN dlx typescript-language-server
```

---

# Summary Statistics

## Total Languages Researched: 25
*(RON removed - CUE handles validation via custom schemas)*

### Complete Coverage (Linter + Formatter):
**11 languages** have both linter and formatter:
1. **CSS** - Biome (linter), malva/Biome (formatters), tree-sitter-css
2. **TOML** - taplo (linter + formatter + schema validation), tree-sitter-toml
3. **JSON** - Biome (linter + formatter), dprint-plugin-json, tree-sitter-json
4. **HTML** - Biome (linter), markup_fmt/Biome (formatters), tree-sitter-html
5. **Markdown** - 6 Rust linters (mado, rumdl, quickmark, checkmark, mdlinker, mdcheck), dprint-plugin-markdown/rumdl (formatters)
6. **TypeScript** - Biome/oxlint (linters), Biome/dprint (formatters), tree-sitter-typescript
7. **JavaScript** - Biome/oxlint (linters), Biome/dprint (formatters), tree-sitter-javascript
8. **PHP** - mago (Rust linter + formatter), tree-sitter-php
9. **Lua** - selene (Rust linter), stylua (Rust formatter), tree-sitter-lua
10. **Python** - ruff (Rust linter + formatter unified), tree-sitter-python
11. **Nix** - statix/deadnix (Rust linters), nixfmt/nixpkgs-fmt/alejandra (Rust formatters), tree-sitter-nix
12. **CUE** - cue vet (Go linter), cue fmt (Go formatter), tree-sitter-cue
13. **Rust** - clippy (linter), rustfmt (formatter), tree-sitter-rust
14. **Go** - golangci-lint (linter), gofmt/gofumpt (formatters), tree-sitter-go

### Partial Coverage (Formatter OR Linter Only):
**4 languages** have partial Rust/Go/Zig coverage:
- **YAML** - Formatter only (pretty_yaml - Rust)
- **Bash** - Formatter only (shfmt - Go), linter is Haskell (shellcheck)
- **Nushell** - Formatter only (nufmt - Rust)
- **Fish** - None (fish_indent is C++, not counted)

### Languages with NO Rust/Go/Zig Tools:
**6 languages** have NO tools in Rust/Go/Zig (except syntax highlighters):
1. **Java** - All tools are Java-based
2. **Kotlin** - All tools are Kotlin-based
3. **PowerShell** - All tools are PowerShell/C#-based
4. **C#** - All tools are C#/.NET-based
5. **C/C++** - All tools are C++-based (clang-tidy, clang-format, cppcheck)
6. **Julia** - All tools are Julia-based
7. **WASM** - All tools are C++-based (wabt)

---

## Most Commonly Used Tools Across Multiple Languages:

### 1. **Biome** (Rust)
Supports: JavaScript, TypeScript, JSON, CSS, HTML (partial), GraphQL
- All-in-one linter + formatter
- 97% Prettier compatibility
- 10-100x faster than ESLint/Prettier

### 2. **dprint** (Rust - framework)
Supports: TypeScript, JavaScript, JSON, Markdown, TOML, CSS (via malva), YAML (via pretty_yaml), HTML (via markup_fmt)
- Plugin-based architecture
- WASM plugins for extensibility
- Highly configurable

### 3. **tree-sitter** (Rust)
Supports: ALL languages researched
- Universal syntax highlighting solution
- Incremental parsing
- Language-agnostic framework

### 4. **taplo** (Rust)
Supports: TOML only
- Linter, formatter, schema validation, LSP server
- De-facto TOML standard

### 5. **ruff** (Rust)
Supports: Python only
- Unified linter + formatter
- 10-100x faster than traditional Python tools
- Replaces flake8, black, isort, pylint, etc.

---

## Key Findings:

1. **Rust dominates modern tooling**: Most new, high-performance tools are written in Rust (Biome, ruff, mago, selene, taplo, stylua, 6+ Markdown linters)

2. **Go has strong presence in infrastructure languages**: Go tooling (gofmt, golangci-lint, shfmt, cue) is prevalent for system languages

3. **Zig tooling is minimal**: No significant Zig-based linters/formatters found in research

4. **Language-specific ecosystems resist cross-language tools**: Java, Kotlin, C#, C/C++, Julia, PowerShell all use native-language tools (but PHP now has Rust alternative: mago)

5. **Syntax highlighting is universal**: tree-sitter provides Rust-based parsers for ALL 25 languages

6. **dprint is the unifying formatter**: dprint plugins cover 10+ languages via Rust framework

7. **Modern trend**: Rust tools (Biome, oxlint, ruff, mago) are replacing JavaScript/Python/PHP tools with 10-100x performance improvements

8. **Biome is multi-language champion**: Now covers JavaScript, TypeScript, JSON, CSS, HTML with unified linter + formatter

9. **Markdown has rich Rust ecosystem**: 6 different Rust linters discovered (mado, rumdl, quickmark, checkmark, mdlinker, mdcheck)

---

## Recommendations:

### For a comprehensive LSP-compatible tooling stack:

**Use Rust-first approach:**
- **Formatter:** dprint (covers 10+ languages)
- **Linters:** Biome (JS/TS/JSON/CSS/HTML), ruff (Python), mago (PHP), selene (Lua), clippy (Rust), taplo (TOML)
- **Markdown linters:** rumdl (most actively maintained), mado, quickmark (LSP support), checkmark (AI-powered)
- **Syntax highlighting:** tree-sitter (all 25 languages)
- **Language-specific:**
  - Nix: nixfmt + statix + deadnix
  - Go: gofmt + golangci-lint
  - Bash: shfmt (Go)
  - CUE: cue fmt + cue vet (Go)

**Accept non-Rust tools where necessary:**
- Java: google-java-format (Java)
- Kotlin: ktlint (Kotlin)
- C#: dotnet format or csharpier (C#)
- C/C++: clang-format, clang-tidy (C++)
- PowerShell: PSScriptAnalyzer (PowerShell)
- Julia: JuliaFormatter.jl (Julia)

**Avoid (no good Rust/Go/Zig alternatives):**
- Fish: Use built-in fish_indent (C++)
- WASM: Use wabt tools (C++)

---

# Primary Research Sources

## 1. Linters/Formatters/Type Checkers as Plugins

### dprint Plugin Catalog
- **URL:** https://plugins.dprint.dev/
- **Description:** Official plugin directory
- **Coverage:** TypeScript, JSON, Markdown, TOML, Dockerfile, Biome, Ruff, Jupyter, and community plugins
- **Format:** WASM and process plugins

### Biome Plugin Ecosystem
- **Status:** No plugin/extension directory exists
- **Architecture:** Monolithic toolchain without traditional plugin support
- **Note:** Functionality built into core binary

## 2. CLI Tools (Rust, Go, Zig)

### Rust CLI Catalogs
- https://github.com/rust-unofficial/awesome-rust
- https://lib.rs/command-line-utilities
- https://github.com/unpluggedcoder/awesome-rust-tools
- https://github.com/matu3ba/awesome-cli-rust
- https://github.com/pa-0/AWESOME-rust-cli

### Go CLI Catalogs
- https://github.com/avelino/awesome-go (main catalog, see Command Line section)
- https://awesome-go.com/standard-cli/
- https://github.com/mantcz/awesome-go-cli
- https://github.com/gobuild/awesome-go-tools

### Zig CLI Catalogs
- https://github.com/zigcc/awesome-zig
- https://zigistry.dev/ (Zig package registry)
- **Notable frameworks:** zig-cli, zig-clap, yazap, cova, zli

## 3. LSP Solutions

### LSP Server Directories
- **https://langserver.org/** - Community-driven, comprehensive list with capability matrices
- **https://github.com/microsoft/language-server-protocol** - Official Microsoft list in implementors section
- **https://wiki.archlinux.org/title/Language_Server_Protocol** - Arch Linux curated list

## Additional Sources
- GitHub trending (Rust/Go projects)
- crates.io registry
- Web search for recent releases (2024-2025)
- Official language documentation

---

**Catalog Verification Date:** 2025-10-27
**Last Updated:** 2025-10-28

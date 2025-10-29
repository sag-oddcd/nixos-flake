{pkgs, ...}: {
  # Neovim
  programs.neovim = {
    enable = true;
    package = pkgs.neovim; # Nightly from neovim-nightly-overlay
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Development packages
  home.packages = with pkgs; [
    # === Rust ecosystem ===
    (rust-bin.selectLatestNightlyWith (toolchain:
      toolchain.default.override {
        extensions = ["rust-src" "rust-analyzer" "clippy"];
      }))
    cargo-binstall
    cargo-update
    cargo-edit
    cargo-watch

    # === Node.js/Bun ===
    bun
    nodejs # Version-agnostic (latest)
    pnpm

    # === Python ===
    uv
    python3 # Version-agnostic (latest - currently 3.14.0rc2)

    # === Go ===
    go

    # === Zig ===
    zig
    zls # Zig LSP

    # === Kotlin ===
    kotlin # kotlinc compiler
    kotlin-language-server

    # === Haskell ===
    ghc # Haskell compiler
    cabal-install # Haskell build tool

    # === C/C++ ===
    clang # Clang compiler
    llvmPackages.libcxx # C++ standard library

    # === C# ===
    dotnet-sdk

    # === Build tools ===
    buck2 # Meta's build system
    cmake
    ninja # Fast build executor (use with cmake -G Ninja)
    gnumake
    # meson # Removed per user request

    # === LSP servers ===
    lua-language-server
    clang-tools # clangd
    omnisharp-roslyn
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted # JSON/HTML/CSS
    yaml-language-server
    bash-language-server
    marksman # Markdown LSP
    nixd # Nix LSP
    taplo # TOML LSP + formatter

    # === Formatters & Linters ===
    biome # JS/TS/JSON linter+formatter
    dprint # Multi-language formatter
    stylua # Lua formatter
    ruff # Python linter+formatter
    rumdl # Markdown linter+formatter (Rust)
    shfmt # Shell formatter
    shellcheck # Shell linter
    yamllint # YAML linter
    go-tools # Go linter (includes staticcheck)
    hlint # Haskell linter
    ormolu # Haskell formatter
    nodePackages.stylelint # CSS linter

    # === Package Managers ===
    luarocks # Lua package manager
    conan # C/C++ package manager

    # === Cloud & AI ===
    awscli2
  ];
}

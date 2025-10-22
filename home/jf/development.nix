{ config, pkgs, inputs, ... }:

{
  # Neovim
  programs.neovim = {
    enable = true;
    package = pkgs.neovim;  # Use nightly from overlay
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Development packages
  home.packages = with pkgs; [
    # === Rust ecosystem ===
    (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
      extensions = [ "rust-src" "rust-analyzer" "clippy" ];
    }))
    cargo-binstall
    cargo-update
    cargo-edit
    cargo-watch

    # === Node.js/Bun ===
    bun
    nodejs_22
    pnpm

    # === Python ===
    uv
    python312

    # === Go ===
    go

    # === Zig ===
    zig
    zls  # Zig LSP

    # === Build tools ===
    cmake
    gnumake
    meson
    ninja

    # === LSP servers ===
    lua-language-server
    clang-tools  # clangd
    omnisharp-roslyn
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted  # JSON/HTML/CSS
    yaml-language-server
    bash-language-server
    marksman  # Markdown LSP

    # === Formatters & Linters ===
    biome          # JS/TS/JSON linter+formatter
    dprint         # Multi-language formatter
    stylua         # Lua formatter
    ruff           # Python linter+formatter
    shfmt          # Shell formatter
    shellcheck     # Shell linter
    yamllint       # YAML linter

    # === Cloud & AI ===
    awscli2
  ];
}

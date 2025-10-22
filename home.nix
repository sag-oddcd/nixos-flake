{ config, pkgs, inputs, ... }:

{
  home.username = "jf";
  home.homeDirectory = "/home/jf";
  home.stateVersion = "24.11";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Fish Shell
  programs.fish = {
    enable = true;
    plugins = [
      # Will be managed by fisher
    ];
    shellInit = ''
      # Fisher plugin manager
      if not functions -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
      end

      # fish_add_path for PATH management
      fish_add_path ~/.local/bin
      fish_add_path ~/.cargo/bin

      # Claude Code runtime paths
      set -gx CLAUDE_RUNTIME_DIR ~/.claude/runtime
      set -gx CLAUDE_NODE_DIR ~/.claude/runtime/node/current
      set -gx CLAUDE_PYTHON_DIR ~/.claude/runtime/python
      set -gx CLAUDE_PNPM_BIN ~/.claude/runtime/node/current/bin/pnpm
      set -gx CLAUDE_UVX_BIN ~/.claude/runtime/python/bin/uvx
      set -gx CLAUDE_NODE_BIN ~/.claude/runtime/node/current/bin/node
      set -gx CLAUDE_PYTHON_BIN ~/.claude/runtime/python/bin/python
      set -gx CLAUDE_UV_BIN ~/.claude/runtime/python/bin/uv
      set -gx CLAUDE_NPM_BIN ~/.claude/runtime/node/current/bin/npm

      # Environment variables
      set -gx EDITOR nvim
      set -gx VISUAL nvim
    '';
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Zoxide navigation
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Atuin shell history
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
    };
  };

  # FZF fuzzy finder
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Bat (cat replacement)
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };

  # Eza (ls replacement)
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = true;
  };

  # Git
  programs.git = {
    enable = true;
    userName = "jf";
    userEmail = "jf@example.com";  # Update with your email
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
      };
    };
  };

  # Jujutsu (Git alternative)
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "jf";
        email = "jf@example.com";  # Update with your email
      };
    };
  };

  # GitUI
  programs.gitui.enable = true;

  # Neovim
  programs.neovim = {
    enable = true;
    package = pkgs.neovim;  # Use nightly from overlay
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Wezterm terminal
  programs.wezterm = {
    enable = true;
  };

  # Yazi file manager
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  # Qutebrowser
  programs.qutebrowser = {
    enable = true;
    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?q={}";
      g = "https://www.google.com/search?q={}";
      gh = "https://github.com/search?q={}";
    };
  };

  # Direnv for per-directory environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # User packages - All Rust-native tools + development tools
  home.packages = with pkgs; [
    # === Browsers ===
    brave
    vivaldi

    # === Terminal Utilities (Rust-native) ===
    # File operations
    fd              # find replacement
    ripgrep         # grep replacement
    sd              # sed replacement
    choose          # cut/awk replacement

    # System monitoring
    bottom          # btm - top/htop replacement
    procs           # ps replacement
    gping           # ping with graph

    # Navigation & productivity
    tealdeer        # tldr - quick command help
    tokei           # code statistics
    hyperfine       # benchmarking

    # Data processing
    jq              # JSON processor
    jaq             # jq alternative (Rust)

    # Task runners
    just            # make replacement
    watchexec       # file watcher

    # VCS tools
    lazygit         # Git TUI (fallback)

    # Dotfiles
    dotter          # dotfile manager

    # Misc utilities
    du-dust         # du replacement
    dua             # disk usage analyzer

    # === Development Tools ===
    # Rust ecosystem
    (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
      extensions = [ "rust-src" "rust-analyzer" "clippy" ];
    }))
    cargo-binstall
    cargo-update
    cargo-edit
    cargo-watch

    # Node.js/Bun
    bun
    nodejs_22
    pnpm

    # Python
    uv
    python312

    # Go
    go

    # Zig
    zig
    zls  # Zig LSP

    # Build tools
    cmake
    gnumake
    meson
    ninja

    # LSP servers
    lua-language-server
    clang-tools  # clangd
    omnisharp-roslyn
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted  # JSON/HTML/CSS
    yaml-language-server
    bash-language-server
    marksman  # Markdown LSP

    # Formatters & Linters
    biome          # JS/TS/JSON linter+formatter
    dprint         # Multi-language formatter
    stylua         # Lua formatter
    ruff           # Python linter+formatter
    shfmt          # Shell formatter
    shellcheck     # Shell linter
    yamllint       # YAML linter

    # === Productivity Tools ===
    # Clipboard
    wl-clipboard

    # Text expansion
    espanso

    # Theme manager
    tinty

    # Password management
    _1password
    _1password-gui

    # === Wayland Tools ===
    wayshot        # Screenshots
    waylock        # Screen lock
    wl-clipboard   # Clipboard
    wlr-randr      # Display config

    # === Window Manager ===
    # Pinnacle will be configured separately

    # === Application Launcher ===
    # Onagre (Wayland launcher)

    # === Input Devices ===
    # Kanata will be configured as service

    # === Databases ===
    # SurrealDB (Docker)

    # === System Utilities ===
    ventoy-full    # Bootable USB creator
    htop           # System monitor (fallback)
    ncdu           # Disk usage
    unzip
    zip
    p7zip

    # === Network tools ===
    wget
    curl
    rsync
    openssh

    # === Media ===
    mpv

    # === Documentation ===
    man-pages
    tldr

    # === Cloud & AI ===
    awscli2

    # === Misc ===
    tree
    file
    which

  ];

  # XDG directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "qutebrowser";
    TERMINAL = "wezterm";
  };

  # GTK theming
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}

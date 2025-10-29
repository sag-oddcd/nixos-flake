{pkgs, ...}: {
  programs = {
    # Bat (cat replacement)
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
      };
    };

    # Eza (ls replacement)
    eza = {
      enable = true;
      enableFishIntegration = true;
      git = true;
      icons = "auto"; # Changed from boolean to string
    };

    # Yazi file manager
    yazi = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  # All Rust-native CLI tools
  home.packages = with pkgs; [
    # === Shells ===
    nushell # Modern shell written in Rust

    # === Terminal Utilities (Rust-native) ===
    # File operations
    fd # find replacement
    ripgrep # grep replacement
    sd # sed replacement
    choose # cut/awk replacement

    # System monitoring
    bottom # btm - top/htop replacement
    procs # ps replacement
    gping # ping with graph

    # Navigation & productivity
    tealdeer # tldr - quick command help
    tokei # code statistics
    hyperfine # benchmarking

    # Data processing
    jq # JSON processor
    jaq # jq alternative (Rust)

    # Task runners
    just # make replacement
    watchexec # file watcher

    # VCS tools
    lazygit # Git TUI (fallback)
    jujutsu_git # Jujutsu VCS (from chaotic-nyx overlay)

    # Dotfiles
    dotter # dotfile manager

    # Misc utilities
    du-dust # du replacement
    dua # disk usage analyzer

    # Archive/compression tools
    libarchive # bsdtar
    archivefs # Mount archives as filesystems (Go)
    backhand # SquashFS tools (Rust)

    # System info
    macchina # System info (Rust)
    onefetch # Git repo info (Rust)

    # === System Utilities ===
    htop # System monitor (fallback)
    ncdu # Disk usage
    unzip
    zip
    p7zip

    # === Input Tools ===
    kanata # Keyboard remapper (Rust)

    # === Network tools ===
    wget
    curl
    xh # Modern HTTP client (Rust, httpie alternative)
    rsync
    openssh
    nmap # Network scanner
    rustscan # Fast port scanner (Rust, uses nmap)
    bandwhich # Bandwidth monitor by process (Rust)

    # === Media ===
    mpv

    # === Documentation ===
    man-pages
    tldr

    # === Misc ===
    tree
    file
    which
  ];
}

{ config, pkgs, ... }:

{
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

  # Yazi file manager
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  # All Rust-native CLI tools
  home.packages = with pkgs; [
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

    # === System Utilities ===
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

    # === Misc ===
    tree
    file
    which
  ];
}

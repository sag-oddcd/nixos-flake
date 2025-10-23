{
  pkgs,
  inputs,
  ...
}: {
  # Wezterm terminal (nightly)
  programs.wezterm = {
    enable = true;
    package = inputs.wezterm.packages.${pkgs.system}.default;
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

  # Desktop applications
  home.packages = with pkgs; [
    # === Browsers ===
    brave
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
      # Note: Vivaldi Snapshot not available in nixpkgs (isSnapshot parameter removed)
    })

    # === Wayland Tools ===
    wayshot # Screenshots
    waylock # Screen lock
    wl-clipboard # Clipboard
    wlr-randr # Display config

    # === Productivity Tools ===
    espanso # Text expansion
    tinty # Theme manager

    # === Password management ===
    _1password-cli # CLI (renamed from _1password)
    _1password-gui # GUI

    # === Media ===
    glide-media-player # Rust-based media player (GTK + GStreamer)

    # === System Utilities ===
    # ventoy-full # Removed: marked as insecure (binary blobs)
  ];

  # GTK theming
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}

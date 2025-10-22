{ config, pkgs, ... }:

{
  # Wezterm terminal
  programs.wezterm = {
    enable = true;
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
    vivaldi

    # === Wayland Tools ===
    wayshot        # Screenshots
    waylock        # Screen lock
    wl-clipboard   # Clipboard
    wlr-randr      # Display config

    # === Productivity Tools ===
    espanso        # Text expansion
    tinty          # Theme manager

    # === Password management ===
    _1password
    _1password-gui

    # === System Utilities ===
    ventoy-full    # Bootable USB creator
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

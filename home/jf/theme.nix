# Desktop Theming - BeautyLine Icon Theme + GTK/Qt Configuration
# Part of modular home-manager configuration

{ config, pkgs, ... }:

{
  # GTK Configuration with BeautyLine Icons
  gtk = {
    enable = true;

    iconTheme = {
      name = "BeautyLine";
      package = pkgs.beautyline-garuda;  # From overlay
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Qt Configuration (use GTK theme)
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # Cursor theme
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Install additional theme-related packages
  home.packages = with pkgs; [
    gnome-themes-extra   # GTK themes
    adwaita-qt           # Qt theme matching
    hicolor-icon-theme   # Fallback icon theme
    adwaita-icon-theme   # Symbolic icons fallback
  ];
}

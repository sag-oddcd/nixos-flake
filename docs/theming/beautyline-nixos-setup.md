# BeautyLine Icon Theme - NixOS Setup

## Option 1: Quick Setup (Original BeautyLine from nixpkgs)

### Home Manager Configuration

```nix
{
  gtk = {
    enable = true;
    iconTheme = {
      name = "BeautyLine";
      package = pkgs.BeautyLine;
    };
  };

  # For Qt applications
  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
  };
}
```

### System-wide Configuration (NixOS)

```nix
environment.systemPackages = with pkgs; [
  BeautyLine
  hicolor-icon-theme  # Fallback theme
];
```

**Pros:**
- Available directly in nixpkgs
- Easy to install
- Declarative, reproducible

**Cons:**
- Original version only (5,233 icons)
- Missing Garuda enhancements (+485 icons)
- No Candy Icons integration

---

## Option 2: Garuda Fork (Recommended - 5,718 icons)

### Create Custom Package

Create `overlays/beautyline-garuda.nix` in your flake:

```nix
final: prev: {
  beautyline-garuda = prev.stdenv.mkDerivation {
    pname = "beautyline-garuda";
    version = "2024.11.28";

    src = prev.fetchFromGitHub {
      owner = "Tekh-ops";
      repo = "Garuda-Linux-Icons";
      rev = "master";  # Or specific commit hash for reproducibility
      sha256 = "";  # Run first time, nix will tell you correct hash
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/icons/BeautyLine
      cp -r * $out/share/icons/BeautyLine/

      # Fix badly named files if present
      find $out/share/icons/BeautyLine -name "*.svg\\n.svg" -exec sh -c 'mv "$1" "''${1%.svg\\n.svg}.svg"' _ {} \;

      # Generate icon cache
      ${prev.gtk3}/bin/gtk-update-icon-cache $out/share/icons/BeautyLine || true

      runHook postInstall
    '';

    meta = with prev.lib; {
      description = "BeautyLine icon theme - Garuda Linux fork with Candy Icons";
      homepage = "https://github.com/Tekh-ops/Garuda-Linux-Icons";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };
}
```

### Flake Configuration

In your `flake.nix`:

```nix
{
  description = "NixOS configuration";

  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations.yourhost = nixpkgs.lib.nixosSystem {
      modules = [
        # Add overlay
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [
            (import ./overlays/beautyline-garuda.nix)
          ];
        })

        ./configuration.nix
      ];
    };
  };
}
```

### Home Manager Configuration (with Garuda fork)

```nix
{
  gtk = {
    enable = true;
    iconTheme = {
      name = "BeautyLine";
      package = pkgs.beautyline-garuda;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
  };
}
```

### Get the Correct SHA256 Hash

```bash
# First run will fail and show you the correct hash
nix-build -E 'with import <nixpkgs> {}; (import ./overlays/beautyline-garuda.nix) pkgs pkgs'

# Copy the hash from error message and update sha256 in overlay
```

---

## Option 3: Manual Installation (Testing)

For testing before committing to flake:

```bash
# Download and install to user directory
cd /tmp
git clone https://github.com/Tekh-ops/Garuda-Linux-Icons.git
mkdir -p ~/.local/share/icons/BeautyLine
cp -r Garuda-Linux-Icons/* ~/.local/share/icons/BeautyLine/
gtk-update-icon-cache ~/.local/share/icons/BeautyLine
```

Then configure via:
- **GNOME:** Settings → Appearance → Icons → BeautyLine
- **KDE:** Settings → Icons → BeautyLine
- **XFCE:** Settings → Appearance → Icons → BeautyLine

---

## Comparison: Original vs Garuda Fork

| Feature | Original (nixpkgs) | Garuda Fork (overlay) |
|---------|-------------------|----------------------|
| **Total Icons** | 5,233 | 5,718 (+485) |
| **App Icons** | 2,764 | 4,148 (+1,384) |
| **Action Icons** | 169 | 435 (+266) |
| **Candy Icons** | ❌ | ✅ |
| **Gaming Apps** | Good | Excellent |
| **Modern Apps** | Good | Excellent |
| **Installation** | Easy (nixpkgs) | Medium (overlay) |
| **Reproducibility** | ✅ Perfect | ✅ Perfect (with hash) |

---

## Recommended Setup (Best of Both)

```nix
# configuration.nix or home.nix
{ config, pkgs, ... }:

{
  # Use overlay for Garuda fork
  nixpkgs.overlays = [
    (import ./overlays/beautyline-garuda.nix)
  ];

  # Home Manager configuration
  home-manager.users.youruser = {
    gtk = {
      enable = true;

      iconTheme = {
        name = "BeautyLine";
        package = pkgs.beautyline-garuda;
      };

      # Optional: GTK theme that complements BeautyLine
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
    };

    qt = {
      enable = true;
      platformTheme = "gtk";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    beautyline-garuda
    hicolor-icon-theme  # Fallback
    gnome-themes-extra  # GTK themes
    adwaita-qt          # Qt theme matching
  ];
}
```

---

## Troubleshooting

### Icons not showing up

```bash
# Rebuild icon cache
gtk-update-icon-cache ~/.local/share/icons/BeautyLine

# Check GTK icon theme
gsettings get org.gnome.desktop.interface icon-theme
gsettings set org.gnome.desktop.interface icon-theme 'BeautyLine'
```

### Symbolic links broken

Some apps use symbolic icons. Ensure fallback:

```nix
environment.systemPackages = with pkgs; [
  beautyline-garuda
  hicolor-icon-theme   # Important fallback
  adwaita-icon-theme   # For symbolic icons
];
```

### File naming issues

The Garuda repository occasionally has badly named files (with newlines). The overlay includes a fix:

```bash
find . -name "*.svg\n.svg" -exec sh -c 'mv "$1" "${1%.svg\n.svg}.svg"' _ {} \;
```

---

## Next Steps

1. **Test first:** Try Option 3 (manual installation) to preview
2. **Commit to flake:** Implement Option 2 (overlay) for reproducible setup
3. **Configure desktop:** Set BeautyLine in your desktop environment settings
4. **Verify coverage:** Check your most-used apps have proper icons

---

**Generated:** 2025-10-28
**Worktree:** icon-sets
**Repository:** Garuda Linux Icons (5,718 icons)
**License:** GPL-3.0

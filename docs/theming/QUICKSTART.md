# BeautyLine Garuda - Quick Start Guide

## Installation Steps

### Step 1: Add Overlay to Your Flake

Copy `beautyline-garuda-overlay.nix` to your flake's `overlays/` directory:

```bash
# Assuming you're in your NixOS flake directory
mkdir -p overlays
cp /path/to/beautyline-garuda-overlay.nix overlays/
```

### Step 2: Import Overlay in Flake

Edit your `flake.nix`:

```nix
{
  outputs = { nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.yourhost = nixpkgs.lib.nixosSystem {
      modules = [
        # Add overlay
        { nixpkgs.overlays = [ (import ./overlays/beautyline-garuda-overlay.nix) ]; }

        # Your other modules
        ./configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
```

### Step 3: Get SHA256 Hash (First Build Only)

```bash
# This will fail and show the correct hash
nix build .#nixosConfigurations.yourhost.config.system.build.toplevel

# Copy the hash from the error message
# It will look like: "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```

Update `overlays/beautyline-garuda-overlay.nix`:

```nix
sha256 = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";  # Paste here
```

### Step 4: Add to Home Manager

Either:

**Option A:** Import the ready-made config:

```nix
# In your home.nix or as a module import
imports = [
  ./home-manager-beautyline.nix
];
```

**Option B:** Add manually to your home.nix:

```nix
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
};
```

### Step 5: Rebuild

```bash
# For NixOS
sudo nixos-rebuild switch --flake .

# Or for Home Manager standalone
home-manager switch --flake .
```

### Step 6: Verify

```bash
# Check if icons are installed
ls ~/.nix-profile/share/icons/BeautyLine

# Check GTK theme setting
gsettings get org.gnome.desktop.interface icon-theme
# Should output: 'BeautyLine'
```

---

## File Structure

Your flake should look like this:

```
your-nixos-flake/
├── flake.nix
├── configuration.nix
├── overlays/
│   └── beautyline-garuda-overlay.nix  ← Add this
├── home-manager/
│   └── home.nix
│   └── home-manager-beautyline.nix     ← Optional, use this
└── ...
```

---

## Quick Test (Without Flake)

To test before committing to your flake:

```bash
# Manual install to user directory
cd /tmp
git clone https://github.com/Tekh-ops/Garuda-Linux-Icons.git
mkdir -p ~/.local/share/icons/BeautyLine
cp -r Garuda-Linux-Icons/* ~/.local/share/icons/BeautyLine/
gtk-update-icon-cache ~/.local/share/icons/BeautyLine

# Set via gsettings
gsettings set org.gnome.desktop.interface icon-theme 'BeautyLine'

# Or set via your DE's settings GUI
```

---

## Troubleshooting

### Icons not showing

```bash
# Ensure fallback themes are installed
nix-shell -p hicolor-icon-theme adwaita-icon-theme

# Regenerate cache
gtk-update-icon-cache ~/.local/share/icons/BeautyLine
```

### Build fails with "hash mismatch"

This is expected on first build. Copy the **correct hash** from the error message and update the overlay file.

### Qt apps don't use icons

Ensure Qt platform theme is set to GTK:

```nix
qt = {
  enable = true;
  platformTheme = "gtk";  # This is crucial
};
```

---

## Files Provided

| File | Purpose |
|------|---------|
| `beautyline-garuda-overlay.nix` | Nix overlay to package Garuda fork |
| `home-manager-beautyline.nix` | Ready-to-use Home Manager config |
| `beautyline-nixos-setup.md` | Full documentation with all options |
| `ICON_SETS_COMPARISON.md` | Icon set comparison data |
| `beautyline-comparison.html` | Visual comparison (36 icons) |
| `QUICKSTART.md` | This file |

---

## What You Get

✅ **5,718 icons** (Garuda fork, not 5,233 original)
✅ **4,148 app icons** (+50% more than original)
✅ **Candy Icons integration**
✅ **Excellent gaming coverage** (perfect for Steam, Lutris, etc.)
✅ **Modern app support** (Discord, VS Code, Telegram, etc.)
✅ **Vibrant gradient design** on pitch black backgrounds
✅ **Declarative, reproducible** NixOS setup

---

## Next Steps

After installation:
1. Log out and log back in (or restart)
2. Check your favorite apps have proper icons
3. Enjoy the beautiful gradient icons! 🎨

For issues or questions, see `beautyline-nixos-setup.md` for detailed documentation.

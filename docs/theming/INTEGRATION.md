# BeautyLine Theming Integration

## Status: ✅ Integrated

BeautyLine (Garuda fork) has been integrated into the NixOS flake configuration.

## What Was Added

### 1. Overlay (`overlays/beautyline-garuda-overlay.nix`)
- Packages the Garuda Linux fork of BeautyLine
- **5,718 icons** (vs 5,233 in original)
- Includes Candy Icons integration
- Auto-generates icon cache for performance

### 2. Home Manager Module (`home/jf/theme.nix`)
- GTK configuration with BeautyLine icons
- Qt configuration (uses GTK theme)
- Dark theme preference (Adwaita-dark)
- Cursor theme (Adwaita)
- Fallback icon themes for compatibility

### 3. Documentation (`docs/theming/`)
- `beautyline-nixos-setup.md` - Full setup guide
- `QUICKSTART.md` - Quick reference
- `ICON_SETS_COMPARISON.md` - Icon count analysis
- `assets/beautyline-comparison.html` - Visual comparison (36 icons)

## Integration Points

### ✅ Flake Configuration
```nix
# flake.nix (line 65)
nixpkgs.overlays = [
  # ... other overlays
  (import ./overlays/beautyline-garuda-overlay.nix)
];
```

### ✅ Home Manager
```nix
# home/jf/default.nix (line 26)
imports = [
  # ... other modules
  ./theme.nix # GTK/Qt theming, BeautyLine icons
];
```

## How to Use

### First Build (Get SHA256 Hash)

On first build, you'll get a hash mismatch error. This is **expected**:

```bash
# Build to get the correct hash
sudo nixos-rebuild switch --flake .#nixos-workstation

# Error will show something like:
# got: sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

Copy the hash and update `overlays/beautyline-garuda-overlay.nix`:

```nix
sha256 = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";  # Paste here
```

### Subsequent Builds

After updating the hash:

```bash
# Rebuild normally
sudo nixos-rebuild switch --flake .#nixos-workstation

# Or test in VM
sudo nixos-rebuild build-vm --flake .#nixos-workstation
```

## Verification

After rebuild and login:

```bash
# Check installed icons
ls ~/.nix-profile/share/icons/BeautyLine

# Check GTK theme setting
gsettings get org.gnome.desktop.interface icon-theme
# Should output: 'BeautyLine'

# Check icon cache
ls -lh ~/.nix-profile/share/icons/BeautyLine/icon-theme.cache
```

## Desktop Environment Configuration

Icons should be automatically applied. If not, manually set via:

**GNOME:**
```bash
gsettings set org.gnome.desktop.interface icon-theme 'BeautyLine'
```

**KDE Plasma:**
- Settings → Appearance → Icons → BeautyLine

**XFCE:**
- Settings → Appearance → Icons → BeautyLine

**i3/sway/other WMs:**
GTK apps will automatically use BeautyLine via the home-manager configuration.

## What You Get

### Icon Coverage
- **Total:** 5,718 icons
- **Apps:** 4,148 icons (+50% vs original)
- **Actions:** 435 icons
- **Mimetypes:** 809 icons
- **Devices:** 197 icons
- **Places:** 129 icons

### Visual Style
- Modern gradient-based design
- Vibrant colors on dark backgrounds
- Line art aesthetic
- Scalable vector graphics (SVG)

### Special Features
- **Gaming:** Excellent Steam, Lutris, gaming app coverage
- **Development:** VS Code, Atom, Sublime, terminals
- **Modern apps:** Discord, Telegram, Spotify, etc.
- **Candy Icons:** Additional icons from Candy theme

## Customization

### Use Different Icon Theme

Edit `home/jf/theme.nix`:

```nix
gtk.iconTheme = {
  name = "Papirus-Dark";  # Or any other theme
  package = pkgs.papirus-icon-theme;
};
```

Available alternatives in nixpkgs:
- `pkgs.papirus-icon-theme` (Papirus)
- `pkgs.breeze-icons` (Breeze - KDE)
- `pkgs.adwaita-icon-theme` (Adwaita - GNOME)
- `pkgs.numix-icon-theme` (Numix)
- `pkgs.tela-icon-theme` (Tela)

### Change GTK Theme

Edit `home/jf/theme.nix`:

```nix
gtk.theme = {
  name = "Nordic";  # Or any other theme
  package = pkgs.nordic;
};
```

### Disable Dark Mode Preference

Edit `home/jf/theme.nix`:

```nix
gtk.gtk3.extraConfig = {
  gtk-application-prefer-dark-theme = false;
};
```

## Troubleshooting

### Icons Not Showing

```bash
# Regenerate icon cache
nix-shell -p gtk3
gtk-update-icon-cache ~/.nix-profile/share/icons/BeautyLine

# Force GTK to use BeautyLine
gsettings set org.gnome.desktop.interface icon-theme 'BeautyLine'

# Logout and login again
```

### Qt Apps Not Using Theme

Ensure Qt platform theme is set to GTK in `theme.nix`:

```nix
qt = {
  enable = true;
  platformTheme = "gtk";  # This is crucial
};
```

### Hash Mismatch on Update

If the Garuda repository updates:

1. Comment out the overlay in `flake.nix`
2. Rebuild to remove old version
3. Uncomment overlay, set `sha256 = "";`
4. Build again to get new hash
5. Update hash and rebuild

## File Locations

```
worktree-receita-flake/
├── overlays/
│   └── beautyline-garuda-overlay.nix    ← Nix package
├── home/jf/
│   ├── default.nix                      ← Imports theme.nix
│   └── theme.nix                        ← GTK/Qt config
├── docs/theming/
│   ├── INTEGRATION.md                   ← This file
│   ├── beautyline-nixos-setup.md        ← Full documentation
│   ├── QUICKSTART.md                    ← Quick reference
│   ├── ICON_SETS_COMPARISON.md          ← Icon analysis
│   └── assets/
│       └── beautyline-comparison.html   ← Visual comparison
└── flake.nix                            ← Overlay imported here
```

## Next Steps

1. **First Build:** Get SHA256 hash and update overlay
2. **Rebuild:** Apply configuration with correct hash
3. **Verify:** Check icons are installed and applied
4. **Customize:** Adjust theme settings in `theme.nix` if desired

## References

- **Garuda Repository:** https://github.com/Tekh-ops/Garuda-Linux-Icons
- **Original BeautyLine:** https://www.gnome-look.org/p/1425426/
- **Icon Count Analysis:** See `ICON_SETS_COMPARISON.md`
- **Visual Preview:** Open `assets/beautyline-comparison.html` in browser

---

**Integration Date:** 2025-10-28
**Integrated From:** worktree-icon-sets
**Icon Count:** 5,718 (Garuda fork)
**Status:** Ready to build

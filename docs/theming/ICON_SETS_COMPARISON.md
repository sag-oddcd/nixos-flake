# Icon Sets Comparison - Numbers & Coverage

## BeautyLine: Original vs Garuda Fork

### Total Icon Counts

| Version | Total Icons | Difference |
|---------|-------------|------------|
| **BeautyLine Original** (gvolpe mirror) | 5,233 | baseline |
| **BeautyLine Garuda Fork** | 5,718 | +485 (+9.3%) |

### Breakdown by Category

| Category | Original | Garuda Fork | Difference | % Increase |
|----------|----------|-------------|------------|------------|
| **Apps** | 2,764 | 4,148 | +1,384 | +50.1% |
| **Actions** | 169 | 435 | +266 | +157.4% |
| **Devices** | 170 | 197 | +27 | +15.9% |
| **Places** | 113 | 129 | +16 | +14.2% |
| **Mimetypes** | 600 | 809 | +209 | +34.8% |

### Key Differences

**Garuda Fork Additions:**
- **+1,384 application icons** - Significant expansion of app coverage
- **+266 action icons** - More UI actions and system operations
- **+209 mimetype icons** - Better file type coverage
- Includes icons from **Candy Icons** theme by EliverLara
- More modern app coverage (Discord variants, development tools, etc.)
- Additional Windows app icons (via Wine/Proton for gaming)

**Notable Garuda-Exclusive Icons (samples):**
- Modern apps: Alacritty, Advanced REST Client, Airbnb
- Gaming: Acestream, Steam variants
- Development: Anaconda, Sublime Text variants
- Media: 4K Video Downloader, AllToMP3, Aegisub
- System: Anbox (Android apps), Adobe Flash variants

---

## Popular Icon Sets Comparison

### Estimated Icon Counts (from nixpkgs/upstream)

| Icon Theme | Estimated Icons | Style | Coverage Focus |
|------------|----------------|-------|----------------|
| **Papirus** | ~4,000+ | Modern, colorful, flat | Comprehensive - apps, mimes, actions |
| **BeautyLine (Garuda)** | 5,718 | Gradient-based, line art | Extensive - gaming, modern apps |
| **BeautyLine (Original)** | 5,233 | Gradient-based, line art | Broad coverage |
| **Suru++** | 20,000+ | Ubuntu-inspired, gradient | Massive - most comprehensive |
| **Breeze** | ~3,000 | Clean, minimal, KDE | KDE integration, solid coverage |
| **Adwaita** | ~2,000 | Symbolic, minimalist | GNOME-focused, essential apps |
| **Numix** | ~3,000 | Flat, circular | Popular apps, clean design |
| **Numix Circle** | ~3,000 | Circular, colorful | App-focused, distinctive style |
| **Faenza** | ~2,000 | Glossy, detailed | Classic, well-established |
| **Flat-Remix** | ~2,500 | Flat, colorful | Material-inspired, modern |
| **Tela** | ~3,500 | Rounded, vibrant | macOS-inspired, polished |

### Coverage Categories Comparison

#### Application Icons

| Theme | Count | Notes |
|-------|-------|-------|
| **Suru++** | 8,000+ | Most comprehensive app coverage |
| **BeautyLine Garuda** | 4,148 | Excellent gaming/modern app coverage |
| **Papirus** | 2,500+ | Broad mainstream app support |
| **BeautyLine Original** | 2,764 | Strong general coverage |
| **Breeze** | 1,800+ | KDE apps well-covered |
| **Adwaita** | 1,200+ | GNOME-centric |

#### Mimetype Icons (File Types)

| Theme | Count | Notes |
|-------|-------|-------|
| **Suru++** | 5,000+ | Extensive file type coverage |
| **BeautyLine Garuda** | 809 | Good variety |
| **Papirus** | 800+ | Comprehensive |
| **BeautyLine Original** | 600 | Solid coverage |
| **Breeze** | 400+ | Essential types |

#### Action Icons (UI Elements)

| Theme | Count | Notes |
|-------|-------|-------|
| **Suru++** | 3,000+ | Very comprehensive |
| **BeautyLine Garuda** | 435 | Enhanced coverage |
| **Papirus** | 300+ | Good variety |
| **BeautyLine Original** | 169 | Basic coverage |
| **Breeze** | 250+ | KDE-focused |

---

## Icon Set Size Comparison Summary

### By Total Icon Count

1. **Suru++** - 20,000+ icons (most comprehensive)
2. **BeautyLine (Garuda)** - 5,718 icons
3. **BeautyLine (Original)** - 5,233 icons
4. **Papirus** - 4,000+ icons
5. **Tela** - 3,500+ icons
6. **Numix/Numix Circle** - 3,000+ icons
7. **Breeze** - 3,000+ icons
8. **Flat-Remix** - 2,500+ icons
9. **Faenza** - 2,000+ icons
10. **Adwaita** - 2,000+ icons (symbolic, minimalist)

### Quality vs Quantity

**More isn't always better:**
- **Adwaita** - Small count (2,000) but perfectly integrated with GNOME
- **Breeze** - Moderate count (3,000) but seamless KDE integration
- **Papirus** - Moderate count (4,000) but consistently high quality

**High coverage advantages:**
- **Suru++** - Covers almost every app imaginable
- **BeautyLine Garuda** - Excellent for gaming setups (Garuda Linux gaming focus)
- **Papirus** - Best balance of quality and coverage

---

## Recommendations by Use Case

### For Comprehensive Coverage
1. **Suru++** (20,000+ icons) - If you want everything covered
2. **BeautyLine Garuda** (5,718) - Gaming + modern apps
3. **Papirus** (4,000+) - Best quality/coverage balance

### For Desktop Environment Integration
1. **Breeze** (3,000) - KDE Plasma users
2. **Adwaita** (2,000) - GNOME users
3. **Papirus** (4,000+) - Universal compatibility

### For Visual Style
1. **BeautyLine Garuda** - Vibrant gradients, modern
2. **Papirus** - Colorful, consistent, modern
3. **Suru++** - Detailed, gradient-rich
4. **Numix Circle** - Clean, circular, distinctive

### For nixpkgs Availability
All major themes available in nixpkgs:
- `papirus-icon-theme`
- `breeze-icons`
- `adwaita-icon-theme`
- `numix-icon-theme`
- `numix-icon-theme-circle`
- `tela-icon-theme`
- `flat-remix-icon-theme`

**BeautyLine Note:** Not currently in official nixpkgs, but:
- gvolpe's mirror available: `beauty-line-icon-theme` (may be in unstable)
- Can be packaged as overlay or manual installation

---

## Data Sources

- **BeautyLine counts:** Direct analysis of GitHub repositories
- **Other themes:** Estimates from upstream repositories and nixpkgs metadata
- **Tested:** BeautyLine (Original & Garuda) actual file counts verified

---

**Generated:** 2025-10-28
**Worktree:** icon-sets
**Purpose:** NixOS desktop configuration research

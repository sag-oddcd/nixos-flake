# PC Black Screen of Death - NixOS Migration

## Project Structure

- **worktree-flake/**: NixOS flake configuration (connected to https://github.com/sag-oddcd/nixos-flake.git)
- **worktree-migracao/**: NixOS installation preparation and migration
- **worktree-tooling-research/**: Development tooling research (linters, formatters, LSP)
- **worktree-icon-sets/**: Icon theme/set research and evaluation
- **worktree-nixos-install-disk/**: NixOS installation disk creation and configuration
- **worktree-partitioning-security/**: Disk partitioning and security setup

## Worktrees

This project uses Git worktrees to separate concerns:

```bash
# Main worktree (master)
/home/jf/projects/pc_black_screen_of_death/

# Worktree 1: NixOS flake configuration
/home/jf/projects/pc_black_screen_of_death/worktree-flake/

# Worktree 2: Migration preparation
/home/jf/projects/pc_black_screen_of_death/worktree-migracao/

# Worktree 3: Development tooling
/home/jf/projects/pc_black_screen_of_death/worktree-tooling-research/

# Worktree 4: Icon sets/themes
/home/jf/projects/pc_black_screen_of_death/worktree-icon-sets/

# Worktree 5: NixOS installation disk
/home/jf/projects/pc_black_screen_of_death/worktree-nixos-install-disk/

# Worktree 6: Partitioning and security
/home/jf/projects/pc_black_screen_of_death/worktree-partitioning-security/
```

## Status

- [x] SystemRescue USB created
- [x] NixOS ISO downloaded
- [ ] NixOS USB created
- [ ] NixOS installed
- [ ] Flake recipe recovered

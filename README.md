# PC Black Screen of Death - NixOS Migration

## Project Structure

- **worktree-migracao/**: NixOS installation preparation and migration
- **worktree-receita-flake/**: Search and documentation of NixOS flake recipe
- **worktree-tooling-research/**: Development tooling research (linters, formatters, LSP)
- **worktree-icon-sets/**: Icon theme/set research and evaluation

## Worktrees

This project uses Git worktrees to separate concerns:

```bash
# Main worktree (master)
/home/jf/projects/pc_black_screen_of_death/

# Worktree 1: Migration preparation
/home/jf/projects/pc_black_screen_of_death/worktree-migracao/

# Worktree 2: Flake recipe search
/home/jf/projects/pc_black_screen_of_death/worktree-receita-flake/

# Worktree 3: Development tooling
/home/jf/projects/pc_black_screen_of_death/worktree-tooling-research/

# Worktree 4: Icon sets/themes
/home/jf/projects/pc_black_screen_of_death/worktree-icon-sets/
```

## Status

- [x] SystemRescue USB created
- [x] NixOS ISO downloaded
- [ ] NixOS USB created
- [ ] NixOS installed
- [ ] Flake recipe recovered

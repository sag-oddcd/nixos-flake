# PC Black Screen of Death - NixOS Migration

## Project Structure

- **worktree-migracao/**: NixOS installation preparation and migration
- **worktree-receita-flake/**: Search and documentation of NixOS flake recipe

## Worktrees

This project uses Git worktrees to separate concerns:

```bash
# Main worktree (master)
/home/jf/projects/pc_black_screen_of_death/

# Worktree 1: Migration preparation
/home/jf/projects/pc_black_screen_of_death/worktree-migracao/

# Worktree 2: Flake recipe search
/home/jf/projects/pc_black_screen_of_death/worktree-receita-flake/
```

## Status

- [x] SystemRescue USB created
- [x] NixOS ISO downloaded
- [ ] NixOS USB created
- [ ] NixOS installed
- [ ] Flake recipe recovered

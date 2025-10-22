# Watchexec Auto-Commit-Push Hook

This directory includes an auto-commit-push system using `watchexec` + `jujutsu` + `github`.

## How It Works

The `.watchexec.sh` script monitors file changes and automatically:
1. Detects changes via `jj status`
2. Creates a commit with timestamp
3. Pushes to GitHub remote

## Usage

### Manual Start

```bash
# From this directory
watchexec -w . -e nix,md,sh ./.watchexec.sh
```

**Options:**
- `-w .` - Watch current directory
- `-e nix,md,sh` - Watch only .nix, .md, and .sh files
- `./.watchexec.sh` - Run the hook script

### Run in Background

```bash
# Start in background
nohup watchexec -w . -e nix,md,sh ./.watchexec.sh > watchexec.log 2>&1 &

# Check log
tail -f watchexec.log

# Stop
pkill -f watchexec
```

### As Systemd Service (NixOS)

Add to your `configuration.nix`:

```nix
systemd.user.services.nixos-flake-watcher = {
  description = "Auto-commit NixOS flake changes";
  after = [ "network.target" ];
  wantedBy = [ "default.target" ];

  serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.watchexec}/bin/watchexec -w /etc/nixos -e nix,md,sh /etc/nixos/.watchexec.sh";
    Restart = "on-failure";
    RestartSec = "10s";
  };
};
```

Then:
```bash
systemctl --user enable nixos-flake-watcher
systemctl --user start nixos-flake-watcher
systemctl --user status nixos-flake-watcher
```

## Customization

### Change Commit Message Format

Edit `.watchexec.sh`:

```bash
jj describe -m "feat: Your custom message

Details here"
```

### Watch Different Files

```bash
# Watch all files
watchexec -w . ./.watchexec.sh

# Watch only configuration files
watchexec -w . -e nix ./.watchexec.sh

# Ignore certain patterns
watchexec -w . -i '*.lock' -i '*.log' ./.watchexec.sh
```

### Add Debouncing

```bash
# Wait 5 seconds after last change
watchexec --debounce 5000 -w . -e nix ./.watchexec.sh
```

## Testing

1. **Test the hook manually:**
   ```bash
   ./.watchexec.sh
   ```

2. **Test with watchexec (dry-run):**
   ```bash
   watchexec --verbose -w . -e nix ./.watchexec.sh
   ```

3. **Make a test change:**
   ```bash
   echo "# Test" >> README_FLAKE.md
   # Watch the auto-commit happen!
   ```

## Troubleshooting

### Hook Not Triggering

```bash
# Check if watchexec is installed
which watchexec

# Check if hook is executable
ls -la .watchexec.sh

# Run hook manually to see errors
bash -x ./.watchexec.sh
```

### Push Fails

```bash
# Check remote configuration
jj git remote -v

# Test manual push
jj git push

# Check GitHub authentication
gh auth status
```

### Too Many Commits

Add debouncing or increase the interval:
```bash
watchexec --debounce 30000 -w . -e nix ./.watchexec.sh
```

## Integration with Claude Code

The hook is aware of Claude Code's workflow and will auto-commit changes made during development sessions.

## Safety

The hook will:
- ✅ Only commit when changes are detected
- ✅ Include timestamps in commit messages
- ✅ Push immediately to GitHub (backup)
- ⚠️ **NOT** run validation before committing (add if needed)

## Disabling

To temporarily disable:
```bash
# Stop background process
pkill -f watchexec

# Or for systemd
systemctl --user stop nixos-flake-watcher
```

## See Also

- [Watchexec Documentation](https://github.com/watchexec/watchexec)
- [Jujutsu Documentation](https://github.com/martinvonz/jj)
- User preferences: `~/.claude/CLAUDE.md` (config-syncing skill)

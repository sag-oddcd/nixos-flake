# RAM Cleanup Guide for Android/Termux/Proot

## Understanding the Environment

```
┌─────────────────────────────────────┐
│         Android System              │  ← System-wide RAM hogs
│  (Chrome, Facebook, Google Play)    │     (200-500 MB each)
├─────────────────────────────────────┤
│           Termux App                │
│  ┌───────────────────────────────┐  │
│  │      Proot (Debian)           │  │  ← Proot-level processes
│  │  • Claude Code (283 MB)       │  │     (570-730 MB total)
│  │  • MCP servers (322 MB)       │  │
│  │  • Watchers, shells, etc.     │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

**Key Insight**: From inside proot, you can only see/kill proot processes, not Android apps.

## Two-Tier Cleanup Strategy

### Tier 1: Proot-Level Cleanup (~322 MB)

**Run from inside proot** (where Claude Code is):

```fish
max-ram
```

This kills non-essential MCP servers:
- visioncraft-mcp (~89 MB)
- sourcegraph-mcp (~89 MB)
- aws-documentation-mcp (~72 MB)
- anthropic-docs-mcp (~72 MB)

**Keeps essential services:**
- Claude Code (main process)
- mcp-server-git (for flake auto-commit)
- mcp-nixos (for NixOS help)

**Effect**: Frees ~322 MB within proot environment.

### Tier 2: System-Wide Cleanup (500-2000 MB)

**Must exit proot first**:

```bash
exit  # Exit Claude Code
exit  # Exit proot
# Now in native Termux
android-free-ram.sh
```

This provides interactive menu to:
1. Kill common RAM hogs (Chrome, Facebook, etc.)
2. Kill ALL background apps
3. Kill specific app by package name
4. Clear system caches
5. Show full memory analysis

**Effect**: Can free 500-2000 MB depending on Android apps running.

## Quick Commands

| Goal | Command | Location | RAM Freed |
|------|---------|----------|-----------|
| Kill MCP servers | `max-ram` | Inside proot | ~322 MB |
| System-wide cleanup | `android-free-ram.sh` | Native Termux | 500-2000 MB |
| Quick proot cleanup | `free-mem` | Inside proot | 20-50 MB |

## Common Scenarios

### Scenario 1: Claude Code running out of memory (Signal 9)

**Immediate fix (inside proot):**
```fish
max-ram
```

**If still crashing:**
```bash
exit  # Exit to native Termux
android-free-ram.sh  # Choose option 1 or 2
# Close Recent Apps manually
# Re-enter proot
```

### Scenario 2: Starting a heavy task

**Proactive cleanup (inside proot):**
```fish
max-ram
```

Then manually close Android apps via Recent Apps button.

### Scenario 3: Maximum possible RAM

**Exit to native Termux and run:**
```bash
android-free-ram.sh  # Choose option 2 (kill all)
```

**Then in Android:**
- Open Recent Apps → Swipe away everything except Termux
- Settings → Apps → Force Stop RAM hogs
- Reboot Android (most effective)

## Top Android RAM Hogs

| App | Package Name | Typical RAM |
|-----|--------------|-------------|
| Chrome | `com.android.chrome` | 200-500 MB |
| Google Play Services | `com.google.android.gms` | 100-300 MB |
| Facebook | `com.facebook.katana` | 100-400 MB |
| Messenger | `com.facebook.orca` | 100-300 MB |
| Instagram | `com.instagram.android` | 100-300 MB |
| WhatsApp | `com.whatsapp` | 100-200 MB |
| YouTube | `com.google.android.youtube` | 100-300 MB |
| Spotify | `com.spotify.music` | 100-200 MB |

## Manual Android Cleanup

**Via Recent Apps:**
1. Press square button or swipe up from bottom
2. Swipe away all apps except Termux
3. Result: 500-1500 MB freed

**Via Settings:**
1. Settings → Apps → See all apps
2. Find RAM hogs (Chrome, Facebook, etc.)
3. Tap → Force Stop
4. Result: 200-500 MB freed per app

**Via Developer Options:**
1. Settings → System → Developer options
2. Background process limit → Set to "At most 2 processes"
3. Don't keep activities → Enable
4. Result: Prevents future RAM buildup

## Memory Monitoring

**Inside proot:**
```bash
free -h  # Shows proot-visible memory
top -bn1 | head -20  # Top processes in proot
```

**In native Termux:**
```bash
dumpsys meminfo | head -30  # System-wide memory
am dumpheap system /sdcard/heap.dump  # Detailed analysis
```

## When to Use Each Tier

| Situation | Use Tier | Command | When |
|-----------|----------|---------|------|
| Claude Code OOM | Tier 1 | `max-ram` | Immediate, no exit needed |
| Still crashing | Tier 2 | `android-free-ram.sh` | After Tier 1 failed |
| Starting heavy task | Tier 1 | `max-ram` | Proactive |
| Long coding session | Both | Both commands | At start |
| Maximum cleanup | Tier 2 + Manual | All methods | Critical low RAM |

## Trade-offs

**Killing MCP servers (Tier 1):**
- ✅ Safe, reversible (restart Claude Code to restore)
- ✅ Immediate effect
- ✅ No data loss
- ❌ Lose MCP tools until restart
- ❌ Limited impact (~322 MB)

**Killing Android apps (Tier 2):**
- ✅ Major RAM freed (500-2000 MB)
- ✅ Most effective
- ❌ Requires exiting Claude Code
- ❌ Lose Android app state (may need to reload)
- ❌ Apps may auto-restart

## Best Practices

1. **Preventive**: Run `max-ram` at session start
2. **Monitor**: Check `free -h` periodically
3. **Aggressive**: Don't wait for OOM - free RAM early
4. **Nuclear**: If frequent crashes, reboot Android daily
5. **Long-term**: Disable unused MCP servers in `~/.mcp.json`

## Files Created

- `/home/jf/.local/bin/android-free-ram.sh` - System-wide cleanup script
- `/home/jf/.config/fish/functions/max-ram.fish` - Proot cleanup function
- `/home/jf/.config/fish/functions/free-mem.fish` - Quick cleanup function
- `/home/jf/.local/bin/free-memory.sh` - Alternative cleanup script

## See Also

- `~/.claude/CLAUDE.md` - OOM crash prevention guidelines
- `/proc/meminfo` - Detailed memory statistics
- `ps aux --sort=-%mem` - Process memory usage

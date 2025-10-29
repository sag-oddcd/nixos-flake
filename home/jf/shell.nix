_: {
  programs = {
    # Fish Shell
    fish = {
      enable = true;
      plugins = [
        # Will be managed by fisher
      ];
      shellInit = ''
        # Fisher plugin manager
        if not functions -q fisher
          curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
        end

        # fish_add_path for PATH management
        fish_add_path ~/.local/bin
        fish_add_path ~/.cargo/bin

        # Claude Code runtime paths
        set -gx CLAUDE_RUNTIME_DIR ~/.claude/runtime
        set -gx CLAUDE_NODE_DIR ~/.claude/runtime/node/current
        set -gx CLAUDE_PYTHON_DIR ~/.claude/runtime/python
        set -gx CLAUDE_PNPM_BIN ~/.claude/runtime/node/current/bin/pnpm
        set -gx CLAUDE_UVX_BIN ~/.claude/runtime/python/bin/uvx
        set -gx CLAUDE_NODE_BIN ~/.claude/runtime/node/current/bin/node
        set -gx CLAUDE_PYTHON_BIN ~/.claude/runtime/python/bin/python
        set -gx CLAUDE_UV_BIN ~/.claude/runtime/python/bin/uv
        set -gx CLAUDE_NPM_BIN ~/.claude/runtime/node/current/bin/npm

        # Environment variables
        set -gx EDITOR nvim
        set -gx VISUAL nvim
      '';
    };

    # Starship prompt
    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    # Zoxide navigation
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    # Atuin shell history
    atuin = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://api.atuin.sh";
      };
    };

    # Skim fuzzy finder (Rust alternative to fzf)
    skim = {
      enable = true;
      enableFishIntegration = true;
    };

    # Direnv for per-directory environments
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

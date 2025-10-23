_: {
  programs = {
    # Git
    git = {
      enable = true;
      settings = {
        user = {
          name = "jf";
          email = "jf@example.com"; # Update with your email
        };
        init.defaultBranch = "main";
        pull.rebase = true;
        core.editor = "nvim";
      };
    };

    # Delta (Git diff viewer)
    delta = {
      enable = true;
      enableGitIntegration = true; # Explicitly enable Git integration
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
      };
    };

    # Jujutsu (Git alternative)
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "jf";
          email = "jf@example.com"; # Update with your email
        };
      };
    };

    # GitUI
    gitui.enable = true;
  };
}

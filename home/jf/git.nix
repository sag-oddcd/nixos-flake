{ config, pkgs, ... }:

{
  # Git
  programs.git = {
    enable = true;
    userName = "jf";
    userEmail = "jf@example.com";  # Update with your email
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
      };
    };
  };

  # Jujutsu (Git alternative)
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "jf";
        email = "jf@example.com";  # Update with your email
      };
    };
  };

  # GitUI
  programs.gitui.enable = true;
}

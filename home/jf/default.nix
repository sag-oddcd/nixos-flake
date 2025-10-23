{...}: {
  home = {
    username = "jf";
    homeDirectory = "/home/jf";
    stateVersion = "24.11";

    # Environment variables
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "qutebrowser";
      TERMINAL = "wezterm";
    };
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Import all user modules
  imports = [
    ./shell.nix # Fish, starship, zoxide, atuin, fzf
    ./git.nix # Git, jujutsu, gitui, delta
    ./cli-tools.nix # All Rust-native CLI tools
    ./development.nix # Neovim, LSPs, dev tools
    ./desktop.nix # Wezterm, browsers, GUI apps
  ];

  # XDG directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}

{pkgs, ...}: {
  # Users
  users.users.jf = {
    isNormalUser = true;
    description = "jf";
    extraGroups = ["networkmanager" "wheel" "video" "audio" "docker"];
    shell = pkgs.fish;
  };

  # Fish shell
  programs.fish.enable = true;

  # Security
  security = {
    sudo-rs.enable = true;
    polkit.enable = true;
    pam.services.greetd.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;

  # Display Manager - greetd with tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd fish";
        user = "greeter";
      };
    };
  };

  # PAM fingerprint authentication
  services.fprintd.enable = true;
  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    greetd.fprintAuth = true;
  };
}

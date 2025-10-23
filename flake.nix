{
  description = "Modular NixOS configuration for jf's workstation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rust overlay for latest toolchains
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim nightly
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Chaotic-nyx overlay (bleeding-edge packages)
    chaotic-nyx = {
      url = "github:chaotic-cx/nyx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # WezTerm nightly
    wezterm = {
      url = "github:wez/wezterm?dir=nix";
    };

    # Pinnacle Wayland compositor
    pinnacle = {
      url = "github:pinnacle-comp/pinnacle";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    rust-overlay,
    neovim-nightly-overlay,
    chaotic-nyx,
    wezterm,
    pinnacle,
    ...
  } @ inputs: {
    nixosConfigurations = {
      nixos-workstation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          # Host configuration (imports all system modules)
          ./hosts/nixos-workstation

          # Overlays
          (_: {
            nixpkgs.overlays = [
              rust-overlay.overlays.default
              neovim-nightly-overlay.overlays.default
              chaotic-nyx.overlays.default
            ];
          })

          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jf = import ./home/jf;
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };
    };
  };
}

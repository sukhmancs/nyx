{
  description = "Xi's NixOS configuration";

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({withSystem, ...}: {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
        inputs.treefmt-nix.flakeModule

        ./flake/lib
        ./flake/default
        ./flake/git-hooks
        ./flake/args.nix
        ./flake/fmt.nix
        ./flake/iso-images.nix
        ./flake/shell
      ];

      flake = {
        nixosConfigurations = import ./machines {inherit inputs withSystem;};
      };
    });

  inputs = {
    systems.url = "github:nix-systems/default-linux";

    # Fork of the Nix package manager
    nix-super.url = "github:privatevoid-net/nix-super";

    # NixOS unstable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small"; # moves faster, has less packages

    # Sometimes nixpkgs breaks something I need, pin a working commit when that occurs
    # nixpkgs-pinned.url = "github:NixOS/nixpkgs/b610c60e23e0583cdc1997c54badfd32592d3d3e";

    # Flake parts for easier flake development
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake utilities
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    # NixOS hardware configuration
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Nix hepler
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # Stylix - System-Wide theme configuration
    stylix.url = "github:danth/stylix";

    # Nix-flake deploy
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs-small";
        utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

    # Documentation generation for module options
    ndg = {
      url = "github:feel-co/ndg";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs-small";
      };
    };

    # A tree-wide formatter
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    nixfmt = {
      url = "github:nixos/nixfmt";
      flake = false;
    };

    # Project shells
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # git-hooks for nix
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs-small";
        flake-compat.follows = "flake-compat";
      };
    };

    # Sandbox wrappers for programs
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs = {
        nixpkgs.follows = "nixpkgs-small";
        flake-parts.follows = "flake-parts";
      };
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Secure-boot support on nixos
    # Avoid on production systems for now
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

    # nix-index database
    nix-index-db = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    atticd = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # Secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs-small";
        home-manager.follows = "home-manager";
        darwin.follows = "";
      };
    };

    # Rust overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs-small";
      };
    };

    # Nix Language server
    nil = {
      url = "github:oxalica/nil";
      inputs = {
        nixpkgs.follows = "nixpkgs-small";
        rust-overlay.follows = "rust-overlay";
      };
    };

    # Nightly builds of Neovim
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs-small";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
      };
    };

    # Notashelf' personal package collection for packages that are
    # not in nixpkgs.
    nyxpkgs.url = "github:NotAShelf/nyxpkgs";

    # Neovim configuration wrapper.
    neovim-flake = {
      url = "github:NotAShelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs-small";
        nil.follows = "nil";
        flake-utils.follows = "flake-utils";
        flake-parts.follows = "flake-parts";
      };
    };

    # Notashelf' wallpapers repository to provide various
    # wallpapers as nix packages.
    wallpkgs = {
      url = "github:NotAShelf/wallpkgs";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # Anyrun program launcher
    anyrun.url = "github:anyrun-org/anyrun";
    anyrun-nixos-options = {
      url = "github:n3oney/anyrun-nixos-options";
      inputs = {
        flake-parts.follows = "flake-parts";
      };
    };

    # Aylur's gtk shell (ags)
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spicetify for theming spotify
    spicetify = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # Schizophrenic Firefox configuration
    schizofox = {
      url = "github:schizofox/schizofox";
      inputs = {
        nixpkgs.follows = "nixpkgs-small";
        flake-parts.follows = "flake-parts";
        nixpak.follows = "nixpak";
      };
    };

    # Mailserver on nixos
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # Hyprland & Hyprland Contrib repos
    # to be able to use the binary cache, we should avoid
    # overriding the nixpkgs input - as the resulting hash would
    # mismatch if packages are built against different versions
    # of the same depended packages.
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    hyprpicker.url = "github:hyprwm/hyprpicker";

    # Hyprland's wallpaper repository
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    # Hyprland's plugins repository
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  # Nix cache configuration
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://cache.privatevoid.net"
      "https://nyx.cachix.org"
      #      "https://cache.xilain.dev"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
      "notashelf.cachix.org-1:VTTBFNQWbfyLuRzgm2I7AWSDJdqAa11ytLXHBhrprZk="
      "nyx.cachix.org-1:xH6G0MO9PrpeGe7mHBtj1WbNzmnXr7jId2mCiq6hipE="
      #     "cache.xilain.dev-1:jmB+1nvzo2i+y71RgmHjMcKjvzkJTs2JtoRbyV4Z4jc="
    ];
  };
}

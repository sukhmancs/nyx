{
  withSystem,
  inputs,
  ...
}: let
  inherit (inputs) self nixpkgs;
  inherit (inputs.self) lib; # I need mkService
  # inherit (lib) mkNixosIso mkNixosSystem mkModuleTree';
  # inherit (lib.lists) concatLists flatten singleton;

  # Inputs
  hw = inputs.nixos-hardware.nixosModules; # hardware compat for pi4 and other quirky devices
  agenix = inputs.agenix.nixosModules.default; # secret encryption via age
  hm = inputs.home-manager.nixosModules.home-manager; # home-manager nixos module

  # Home-manager
  homesPath = ../homes;
  homes = [hm homesPath];

  # Default
  system = "x86_64-linux";
  modulesPath = "${nixpkgs}/nixos/modules";

  # Define role-specific module lists
  workstationRoles = [
    ../modules/workstation
    ../modules/graphical
  ];

  laptopRoles = [
    ../modules/laptop
    ../modules/workstation
    ../modules/graphical
  ];

  serverRoles = [
    ../modules/server
    ../modules/headless
  ];

  isoRoles = [
    ../modules/iso
    ../modules/headless
  ];

  # Define a base configuration function
  baseSystemConfig = {
    hostname,
    roleModules,
    system ? "x86_64-linux",
    agenix,
    enableHome ? true,
  }:
    withSystem system ({
      inputs',
      self',
      ...
    }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          [
            {networking.hostName = hostname;}
            ./${hostname}
            ../modules/core
          ]
          ++ roleModules
          ++ [
            ../options
            agenix
          ]
          ++ (
            if enableHome
            then homes
            else []
          );
        specialArgs = {
          inherit (self) keys;
          inherit lib modulesPath;
          inherit inputs self inputs' self';
        };
      });
in {
  # LAPTOP
  # ASUS TUF FX505D laptop from 2019
  # equipped a Ryzen 7 7730U
  milkyway = baseSystemConfig {
    hostname = "milkyway";
    roleModules = laptopRoles;
    enableHome = true;
    inherit system agenix;
  };

  # DESKTOP
  andromeda = baseSystemConfig {
    hostname = "andromeda";
    roleModules = workstationRoles;
    enableHome = true;
    inherit system agenix;
  };

  # SERVER
  triangulum = baseSystemConfig {
    hostname = "triangulum";
    roleModules = serverRoles;
    enableHome = true;
    inherit system agenix;
  };
  # hermes = withSystem "x86_64-linux" ({
  #   inputs',
  #   self',
  #   ...
  # }:
  #   inputs.nixpkgs.lib.nixosSystem {
  #     system = "x86_64-linux";
  #     modules =
  #       [
  #         {networking.hostName = "hermes";}
  #         ./hermes
  #         ../modules/core # core modules
  #         ../modules/roles/workstation
  #         ../modules/roles/laptop
  #         ../modules/roles/graphical
  #         ../modules/options

  #         agenix # age encryption for secrets
  #       ]
  #       ++ homes;
  #     specialArgs = {
  #       inherit (self) keys;
  #       inherit lib modulesPath;
  #       inherit inputs self inputs' self';
  #     };
  #   });

  # enyo = withSystem "x86_64-linux" ({
  #   inputs',
  #   self',
  #   ...
  # }:
  #   inputs.nixpkgs.lib.nixosSystem {
  #     system = "x86_64-linux";
  #     modules =
  #       [
  #         {networking.hostName = "enyo";}
  #         ./enyo
  #         ../modules/core # core modules
  #         ../modules/roles/workstation
  #         ../modules/roles/graphical
  #         ../modules/options

  #         agenix # age encryption for secrets
  #       ]
  #       ++ homes;
  #     specialArgs = {
  #       inherit (self) keys;
  #       inherit lib modulesPath;
  #       inherit inputs self inputs' self';
  #     };
  #   });
  # My main desktop boasting a RX 6700XT and a Ryzen 5 3600x
  # fully free from nvidia
  # fuck nvidia - Linus "the linux" Torvalds
  # enyo = mkNixosSystem {
  #   inherit withSystem;
  #   hostname = "enyo";
  #   system = "x86_64-linux";
  #   modules = mkModulesFor "enyo" {
  #     roles = [graphical workstation];
  #     extraModules = [shared homes];
  #   };
  # };

  # # Deprecated
  # prometheus = mkNixosSystem {
  #   inherit withSystem;
  #   hostname = "prometheus";
  #   system = "x86_64-linux";
  #   modules = mkModulesFor "prometheus" {
  #     roles = [graphical workstation laptop];
  #     extraModules = [shared homes];
  #   };
  # };

  # # Identical twin host for Prometheus
  # # provides full disk encryption
  # # with passkey/USB authentication
  # epimetheus = mkNixosSystem {
  #   inherit withSystem;
  #   hostname = "epimetheus";
  #   system = "x86_64-linux";
  #   modules = mkModulesFor "epimetheus" {
  #     roles = [graphical workstation laptop];
  #     extraModules = [shared homes];
  #   };
  # };

  # # ASUS TUF FX505D laptop from 2019
  # # equipped a Ryzen 7 7730U
  # # usually acts as my portable workstation
  # # similar to epimetheus, has full disk
  # # encryption with ephemeral root using impermanence
  # hermes = mkNixosSystem {
  #   inherit withSystem;
  #   hostname = "hermes";
  #   system = "x86_64-linux";
  #   modules = mkModulesFor "hermes" {
  #     roles = [graphical workstation laptop];
  #     extraModules = [shared homes];
  #   };
  # };

  # # Hetzner VPS to replace my previous server machines
  # # hosts some of my infrastructure
  # helios = mkNixosSystem {
  #   inherit withSystem;
  #   hostname = "helios";
  #   system = "x86_64-linux";
  #   modules = mkModulesFor "helios" {
  #     roles = [server headless];
  #     extraModules = [shared homes];
  #   };
  # };

  # # Hetzner VPS to replace my previous server machines
  # # hosts some of my infrastructure
  # selene = mkNixosSystem {
  #   inherit withSystem;
  #   hostname = "helios";
  #   system = "aarch64-linux";
  #   modules = mkModulesFor "selene" {
  #     roles = [server headless];
  #     extraModules = [shared homes];
  #   };
  # };

  # # Lenovo Ideapad from 2014
  # # Hybrid device
  # # acts as a portable server and a "workstation"
  # icarus = mkNixosSystem {
  #   inherit withSystem;
  #   hostname = "icarus";
  #   system = "x86_64-linux";
  #   modules = mkModulesFor "icarus" {
  #     roles = [graphical workstation laptop server];
  #     extraModules = [shared homes];
  #   };
  # };

  # # Raspberry Pi 400
  # # My Pi400 homelab
  # # used mostly for testing networking/cloud services
  # atlas = mkNixosSystem {
  #   inherit withSystem;
  #   hostname = "atlas";
  #   system = "aarch64-linux";
  #   modules = mkModulesFor "atlas" {
  #     roles = [server headless];
  #     extraModules = [shared hw.raspberry-pi-4];
  #   };
  # };

  # # Self-made live recovery environment that overrides or/and configures certain default programs
  # # provides tools and fixes the keymaps for my keyboard
  # gaea = mkNixosIso {
  #   hostname = "gaea";
  #   system = "x86_64-linux";
  #   specialArgs = {inherit lib;};
  #   modules = mkModulesFor "gaea" {
  #     moduleTrees = [];
  #     roles = [iso headless];
  #     extraModules = [shared];
  #   };
  # };

  # # An air-gapped NixOS live media to deal with
  # # sensitive tooling (e.g. Yubikey, GPG, etc.)
  # # isolated from all networking
  # erebus = mkNixosIso {
  #   inherit withSystem;
  #   hostname = "erebus";
  #   system = "x86_64-linux";
  #   modules = mkModulesFor "erebus" {
  #     moduleTrees = [];
  #     roles = [iso];
  #     extraModules = [shared];
  #   };
  # };

  # # Pretty beefy VM running on my dedicated server
  # # is mostly for testing, but can run services at will
  # leto = mkNixosSystem {
  #   inherit withSystem;
  #   hostname = "leto";
  #   system = "x86_64-linux";
  #   modules = mkModulesFor "leto" {
  #     roles = [server headless];
  #     extraModules = [shared homes];
  #   };
  # };

  # # Twin virtual machine hosts
  # # Artemis is x86_64-linux
  # artemis = mkNixosSystem {
  #   inherit withSystem;
  #   hostname = "artemis";
  #   system = "x86_64-linux";
  #   modules = mkModulesFor "artemis" {
  #     roles = [server headless];
  #     extraModules = [shared];
  #   };
  # };

  # # Apollon is also x86_64-linux
  # # but is for testing server-specific services
  # apollon = mkNixosSystem {
  #   inherit withSystem;
  #   hostname = "apollon";
  #   system = "aarch64-linux";
  #   modules = mkModulesFor "apollon" {
  #     roles = [server headless];
  #     extraModules = [shared];
  #   };
  # };
}

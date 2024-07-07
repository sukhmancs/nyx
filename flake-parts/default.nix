{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
    inputs.git-hooks.flakeModule
    inputs.treefmt-nix.flakeModule

    ./flake/lib
    ./flake/default
    ./flake/git-hooks
    ./flake/args.nix
    ./flake/fmt.nix
    ./flake/iso-images.nix
    ./flake/shell
  ];
}

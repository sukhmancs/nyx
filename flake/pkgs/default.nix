{
  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }: let
    # Dynamically import all Nix files from the directory
    importPackages = directory:
      lib.mapAttrs' (
        name: type:
          pkgs.callPackage (directory + "/" + name + "/package.nix") {}
      ) (builtins.readDir directory);

    # Import all packages from the packages directory
    packages = importPackages ./packages;
  in {
    overlayAttrs = config.packages;
    packages = packages;
    # packages = lib.packagesFromDirectoryRecursive {
    #   inherit (pkgs) callPackage;
    #   directory = ./packages;
    # };
  };
}

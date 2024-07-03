{
  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }: let
    # Dynamically import all Nix files from the directory
    importPackages = directory: let
      directoryPath = builtins.toPath directory;
    in
      lib.mapAttrs' (
        name: type: let
          packagePath = directoryPath + ("/" + name + "/package.nix");
        in
          pkgs.callPackage packagePath {}
      ) (builtins.readDir directoryPath);

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

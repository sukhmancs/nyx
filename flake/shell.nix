#
# devShell - a shell for Nix project. It includes tools for development and
# debugging, such as formatters, linters, and source control tools.
#
# To use this development environment, ensure you have Nix installed and run
# `nix develop` in the directory containing this shell.nix file. This will instantiate
# the shell environment, making all specified commands and packages available for use.
#
{
  perSystem = {
    inputs',
    config,
    pkgs,
    ...
  }: {
    devShells.default = inputs'.devshell.legacyPackages.mkShell {
      name = "config";
      commands = [
        {
          help = "Rebuild the system using nh os switch";
          name = "sw";
          command = "nh os switch";
          category = "build";
        }
        {
          help = "Rebuild the system using nh os boot";
          name = "boot";
          command = "nh os boot";
          category = "build";
        }
        {
          help = "Format the source tree with treefmt";
          name = "fmt";
          command = "treefmt";
          category = "formatter";
        }
        {
          help = "Format nix files with Alejandra";
          name = "alejandra";
          package = "alejandra";
          category = "formatter";
        }
        {
          help = "Fetch source from origin";
          name = "pull";
          command = "git pull";
          category = "source control";
        }
        {
          help = "Format source tree and push commited changes to git";
          name = "push";
          command = "git push";
          category = "source control";
        }
        {
          help = "Update flake inputs and commit changes";
          name = "update";
          command = ''nix flake update && git commit flake.lock -m "flake: bump inputs"'';
          category = "utils";
        }
      ];

      env = [
        {
          # make direnv shut up
          name = "DIRENV_LOG_FORMAT";
          value = "";
        }
      ];

      # packages to include in the shell
      # inputsFrom = [config.treefmt.build.devShell];
      packages = with pkgs; [
        (inputs'.agenix.packages.default.override {ageBin = "${pkgs.rage}/bin/rage";}) # provide agenix CLI within flake shell
        config.treefmt.build.wrapper # A tree-wide formatter
        nil # ls
        alejandra # A formatter for Nix files
        git # source control
        glow # A markdown viewer
        statix # A linter for nix
        deadnix # remove dead code from nix files
        nodejs # Required for various JavaScript-based tools including ags and eslint_d
      ];
    };
  };
}

{
  pkgs,
  inputs',
  config,
}:
with pkgs; [
  (inputs'.agenix.packages.default.override {ageBin = "${pkgs.rage}/bin/rage";}) # provide agenix CLI within flake shell
  config.treefmt.build.wrapper # A tree-wide formatter
  nil # ls
  alejandra # A formatter for Nix files
  git # source control
  glow # A markdown viewer
  statix # A linter for nix
  deadnix # remove dead code from nix files
  nodejs # Required for various JavaScript-based tools including ags and eslint_d
]

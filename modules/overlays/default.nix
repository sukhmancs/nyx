self: super: {
  discord-oa = import ./discord super;
  plymouth-themes = super.callPackage ../pkgs/plymouth-themes.nix {};
}
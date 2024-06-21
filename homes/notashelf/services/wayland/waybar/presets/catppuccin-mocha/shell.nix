{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = [
    (pkgs.waybar.overrideAttrs (oldAttrs: {
      # Assuming config.nix and style.nix return their respective configurations
      # as strings or paths to the actual files.
      postInstall = ''
        mkdir -p $out/share/waybar
        cp ${./config.nix} $out/share/waybar/config
        cp ${./style.nix} $out/share/waybar/style.css
      '';
    }))
  ];

  shellHook = ''
    echo "Run Waybar with: waybar -c $PWD/config -s $PWD/style.css"
  '';
}

{
  lib,
  stdenv,
  callPackages,
  fetchFromGitHub,
  pack ? 2,
  theme ? "green_blocks",
  ...
}: let
  nv = (callPackages ./generated.nix {}).plymouth-themes;
in
  stdenv.mkDerivation rec {
    inherit (nv) pname src;
    version = nv.date;

    strictDeps = true;

    #  src = fetchFromGitHub {
    #    owner = "adi1090x";
    #    repo = "plymouth-themes";
    #    rev = "bf2f570bee8e84c5c20caac353cbe1d811a4745f";
    #    sha256 = "sha256-VNGvA8ujwjpC2rTVZKrXni2GjfiZk7AgAn4ZB4Baj2k=";
    #  };

    configurePhase = ''
      runHook preConfigure
      mkdir -p $out/share/plymouth/themes
      runHook postConfigure
    '';

    installPhase = ''
      runHook preInstall
      cp -r ./pack_${toString pack}/${theme} $out/share/plymouth/themes
      sed -i 's;/usr/share;${placeholder "out"}/share;g' \
        $out/share/plymouth/themes/${theme}/${theme}.plymouth
      runHook postInstall
    '';

    meta = {
      description = "A collection of plymouth themes ported from Android.";
      inherit (src.meta) homepage;
      license = lib.licenses.gpl3;
      platforms = lib.platforms.linux;
    };
  }

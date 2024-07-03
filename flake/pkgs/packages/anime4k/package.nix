{
  lib,
  stdenvNoCC,
  callPackages,
}: let
  nv = (callPackages ./generated.nix {}).nicksfetch;
in
  stdenvNoCC.mkDerivation {
    inherit (nv) pname version;
    src = fetchzip {
      url = nv.src.url;
      stripRoot = false;
      sha256 = nv.src.sha256;
    };

    unpackPhase = "true";

    installPhase = ''
      mkdir $out
      cp *.glsl $out
    '';

    meta = with lib; {
      description = "A High-Quality Real Time Upscaler for Anime Video";
      homepage = "https://github.com/bloc97/Anime4K";
      license = licenses.mit;
      maintainers = with maintainers; [bloc97];
    };
  }

{
  lib,
  stdenvNoCC,
  callPackages,
  fetchzip,
  unzip,
}: let
  nv = (callPackages ./generated.nix {}).anime4k;
in
  stdenvNoCC.mkDerivation {
    inherit (nv) pname version src;
    # src = fetchzip {
    #   url = "https://github.com/bloc97/Anime4K/releases/download/v${nv.version}/Anime4K_v4.0.zip";
    #   stripRoot = false;
    #   sha256 = "18x5q7zvkf5l0b2phh70ky6m99fx1pi6mhza4041b5hml7w987pl";
    # };

    buildInputs = [unzip];

    unpackPhase = ''
      unzip $src
    '';

    # unpackPhase = "true";

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

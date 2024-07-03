{
  lib,
  stdenvNoCC,
  fetchzip,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "anime4k";
  version = "4.0.1";

  # src = fetchzip {
  #   url = "https://github.com/bloc97/Anime4K/releases/download/v${finalAttrs.version}/Anime4K_v4.0.zip";
  #   stripRoot = false;
  #   sha256 = "18x5q7zvkf5l0b2phh70ky6m99fx1pi6mhza4041b5hml7w987pl";
  # };
  src = fetchFromGitHub {
    owner = "bloc97";
    repo = "Anime4K";
    rev = "v${version}";
    sha256 = "1nxh8h00h0smrnq5s6a4zvhxgkz2gaxaq2kggxdkicxi6z6w94wr";
  };

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

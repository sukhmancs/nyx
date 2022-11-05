{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  autoreconfHook,
  pkg-config,
  cairo,
  glib,
  libnotify,
  rofi-wayland-unwrapped,
  wl-clipboard,
  wtype,
}:
stdenv.mkDerivation rec {
  pname = "rofi-emoji-wayland";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YMQG0XO6zVei6GfBdgI7jtB7px12e+xvOMxZ1QHf5kQ=";
  };

  patches = [
    # Look for plugin-related files in $out/lib/rofi
    ./patches/0001-Patch-plugindir-to-output.patch
  ];

  postPatch = ''
    patchShebangs clipboard-adapter.sh
  '';

  postFixup = ''
    chmod +x $out/share/rofi-emoji/clipboard-adapter.sh
    wrapProgram $out/share/rofi-emoji/clipboard-adapter.sh \
      --prefix PATH ":" ${lib.makeBinPath [libnotify wl-clipboard wtype]}
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    cairo
    glib
    libnotify
    rofi-wayland-unwrapped
    wl-clipboard
    wtype
  ];

  meta = with lib; {
    description = "An emoji selector plugin for Rofi";
    homepage = "https://github.com/Mange/rofi-emoji";
    license = licenses.mit;
    maintainers = with maintainers; [cole-h sioodmy];
    platforms = platforms.linux;
  };
}

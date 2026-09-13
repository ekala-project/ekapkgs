{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  freetype,
  imlib2,
  libsm,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxft,
  libxinerama,
  libxrandr,
  libpulseaudio,
  libsndfile,
  pango,
  perl,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "e16";
  version = "1.0.31";

  src = fetchurl {
    url = "mirror://sourceforge/enlightenment/e16-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZQTsIy/BiO/xUiCu+bc2n406F0unAinxyYLjVRfUSiQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    freetype
    imlib2
    libsm
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxft
    libxinerama
    libxrandr
    libpulseaudio
    libsndfile
    pango
    perl
    python3
  ];

  postPatch = ''
    substituteInPlace scripts/e_gen_menu --replace "/usr/local:" "/run/current-system/sw:/usr/local:"
    substituteInPlace scripts/e_gen_menu --replace "'/opt'" "'/opt', '/run/current-system/sw'"
    substituteInPlace scripts/e_gen_menu --replace "'/.local'" "'/.nix-profile', '/.local'"
  '';

  meta = {
    homepage = "https://www.enlightenment.org/e16";
    description = "Enlightenment DR16 window manager";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
  };
})

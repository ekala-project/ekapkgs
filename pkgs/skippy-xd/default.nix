{
  lib,
  stdenv,
  fetchFromGitHub,
  xorgproto,
  libx11,
  libxft,
  libxcomposite,
  libxdamage,
  libxext,
  libxinerama,
  libjpeg,
  giflib,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skippy-xd";
  version = "2026.06.24";

  src = fetchFromGitHub {
    owner = "felixfung";
    repo = "skippy-xd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5qEqzBzjzOufVb8P5qbVYSLmeu2T8p5d88Yb8b8fDhM=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxft
    libxcomposite
    libxdamage
    libxext
    libxinerama
    libjpeg
    giflib
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    sed -e "s@/etc/xdg@$out&@" -i Makefile
    mkdir -p $out/share/man/man1
  '';

  meta = {
    description = "Expose-style compositing-based standalone window switcher";
    homepage = "https://github.com/felixfung/skippy-xd";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

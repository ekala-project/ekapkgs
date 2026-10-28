{
  lib,
  stdenv,
  fetchurl,
  libiconv,
  libpng,
  ncurses,
  readline,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slang";
  version = "2.3.3";

  src = fetchurl {
    url = "https://www.jedsoft.org/releases/slang/slang-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-+RRQVK4TGXPGEgjqgkhtXdEOPFza0jt8SgYXdDyPWhg=";
  };

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  # Fix some wrong hardcoded paths
  preConfigure = ''
    sed -i -e "s|/usr/lib/terminfo|${ncurses.out}/lib/terminfo|" configure
    sed -i -e "s|/usr/lib/terminfo|${ncurses.out}/lib/terminfo|" src/sltermin.c
    sed -i -e "s|/bin/ln|ln|" src/Makefile.in
    sed -i -e "s|-ltermcap|-lncurses|" ./configure
  '';

  configureFlags = [
    "--without-pcre"
    "--with-png=${libpng.dev}"
    "--with-readline=${readline.dev}"
    "--with-z=${zlib.dev}"
  ];

  buildInputs = [
    libpng
    readline
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  propagatedBuildInputs = [ ncurses ];

  buildFlags = lib.optional stdenv.hostPlatform.isStatic "static";
  installTargets = lib.optional stdenv.hostPlatform.isStatic "install-static";

  preBuild = ''
    makeFlagsArray+=(AR_CR="${stdenv.cc.targetPrefix}ar cr")
  '';

  postInstall = ''
    find "$out"/lib/ -name '*.so' -exec chmod +x "{}" \;
    sed '/^Libs:/s/$/ -lncurses/' -i "$dev"/lib/pkgconfig/slang.pc
  '';

  meta = {
    description = "Small, embeddable multi-platform programming library";
    homepage = "http://www.jedsoft.org/slang/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "slsh";
    platforms = lib.platforms.unix;
  };
})

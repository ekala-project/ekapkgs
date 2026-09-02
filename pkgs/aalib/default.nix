{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aalib";
  version = "1.4rc5";

  src = fetchurl {
    url = "mirror://sourceforge/aa-project/aalib-${finalAttrs.version}.tar.gz";
    sha256 = "1vkh19gb76agvh4h87ysbrgy82hrw88lnsvhynjf4vng629dmpgv";
  };

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "info"
  ];
  setOutputFlags = false;

  patches = [
    ./clang.patch
    ./ncurses-6.5.patch
  ];

  preConfigure = ''
    export system
    appendToVar configureFlags \
      "--bindir=$bin/bin" \
      "--includedir=$dev/include" \
      "--libdir=$out/lib"
  ''
  + ''
    substituteInPlace ltconfig \
      --replace-fail 'powerpc*) dynamic_linker=no ;;' ""
  '';

  buildInputs = [ ncurses ];

  configureFlags = [
    "--without-x"
    "--with-ncurses=${ncurses.dev}"
  ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  postInstall = ''
    mkdir -p $dev/bin
    mv $bin/bin/aalib-config $dev/bin/aalib-config
    substituteInPlace $out/lib/libaa.la --replace-fail "${ncurses.dev}/lib" "${ncurses.out}/lib"
  '';

  meta = {
    description = "ASCII art graphics library";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl2;
  };
})

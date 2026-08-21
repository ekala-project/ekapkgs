{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  libx11,
  libxt,
  libxft,
  libxrender,
  libxext,
  ncurses,
  fontconfig,
  freetype,
  pkg-config,
  gdk-pixbuf,
  perl,
  libptytty,
  perlSupport ? true,
  gdkPixbufSupport ? true,
  unicode3Support ? true,
}:

stdenv.mkDerivation rec {
  pname = "rxvt-unicode-unwrapped";
  version = "9.31";

  src = fetchurl {
    url = "http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-${version}.tar.bz2";
    sha256 = "qqE/y8FJ/g8/OR+TMnlYD3Spb9MS1u0GuP8DwtRmcug=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libx11
    libxt
    libxft
    ncurses
    fontconfig
    freetype
    libxrender
    libptytty
  ]
  ++ lib.optionals perlSupport [
    perl
    libxext
  ]
  ++ lib.optional gdkPixbufSupport gdk-pixbuf;

  outputs = [
    "out"
    "terminfo"
  ];

  patches = [
    ./patches/9.06-font-width.patch
    ./patches/256-color-resources.patch
  ]
  ++ lib.optional (perlSupport && lib.versionAtLeast perl.version "5.38") (fetchpatch {
    name = "perl538-locale-c.patch";
    url = "https://github.com/exg/rxvt-unicode/commit/16634bc8dd5fc4af62faf899687dfa8f27768d15.patch";
    excludes = [ "Changes" ];
    sha256 = "sha256-JVqzYi3tcWIN2j5JByZSztImKqbbbB3lnfAwUXrumHM=";
  });

  configureFlags = [
    "--with-terminfo=${placeholder "terminfo"}/share/terminfo"
    "--enable-256-color"
    (lib.enableFeature perlSupport "perl")
    (lib.enableFeature unicode3Support "unicode3")
  ];

  LDFLAGS = [
    "-lfontconfig"
    "-lXrender"
    "-lpthread"
  ];
  CFLAGS = [ "-I${freetype.dev}/include/freetype2" ];

  preConfigure = ''
    # without this the terminfo won't be compiled by tic, see man tic
    mkdir -p $terminfo/share/terminfo
    export TERMINFO=$terminfo/share/terminfo
  ''
  + lib.optionalString perlSupport ''
    # make urxvt find its perl file lib/perl5/site_perl
    # is added to PERL5LIB automatically
    mkdir -p $out/$(dirname ${perl.libPrefix})
    ln -s $out/lib/urxvt $out/${perl.libPrefix}
  '';

  postInstall = ''
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  meta = with lib; {
    description = "A clone of the well-known terminal emulator rxvt";
    homepage = "http://software.schmorp.de/pkg/rxvt-unicode.html";
    downloadPage = "http://dist.schmorp.de/rxvt-unicode/Attic/";
    maintainers = [ ];
    platforms = platforms.unix;
    license = licenses.gpl3;
    mainProgram = "urxvt";
  };
}

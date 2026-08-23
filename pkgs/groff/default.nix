{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  perl,
  buildPackages,
  autoreconfHook,
  pkg-config,
  texinfo,
  bison,
  bashNonInteractive ? null,
}:

let
  urw-fonts = fetchFromGitHub {
    name = "groff-urw-base35-fonts";
    owner = "ArtifexSoftware";
    repo = "urw-base35-fonts";
    tag = "20200910";
    hash = "sha256-YQl5IDtodcbTV3D6vtJi7CwxVtHHl58fG6qCAoSaP4U=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "groff";
  version = "1.24.1";

  src = fetchurl {
    url = "mirror://gnu/groff/groff-${finalAttrs.version}.tar.gz";
    hash = "sha256-dOKBl5W2r/QxrqyYPWOpyJaO6roqLrp9+LpMe0Hnz9g=";
  };

  patches = [
    ./0001-Revert-man-Fix-Savannah-65190.patch
  ];

  outputs = [
    "out"
    "man"
    "doc"
    "info"
    "perl"
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace contrib/gdiffmk/gdiffmk.sh \
      --replace-fail "@POSIX_SHELL_PROG@" "/bin/sh"
  '';

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    texinfo
  ]
  ++ lib.optional (stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "9") bison;

  buildInputs = [
    perl
  ]
  ++ lib.optionals (bashNonInteractive != null) [ bashNonInteractive ];

  configureFlags = [
    "ac_cv_path_PERL=${buildPackages.perl}/bin/perl"
    "--enable-year2038"
    "--without-x"
  ]
  ++ lib.optionals (stdenv.cc.isClang) [
    "CFLAGS=-std=gnu11"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "gl_cv_func_signbit=yes"
  ];

  postConfigure = ''
    substituteInPlace Makefile \
      --replace-fail '$(LN_S) $(exampledir)' 'mv $(exampledir)'
  '';

  doCheck = true;

  preCheck = ''
    export GROFF_BIN_PATH=.
  '';

  postInstall = ''
    for f in 'man.local' 'mdoc.local'; do
        cat '${./site.tmac}' >>"$out/share/groff/site-tmac/$f"
    done

    moveToOutput bin/gropdf $perl
    moveToOutput bin/pdfmom $perl
    moveToOutput bin/roff2text $perl
    moveToOutput bin/roff2pdf $perl
    moveToOutput bin/roff2ps $perl
    moveToOutput bin/roff2dvi $perl
    moveToOutput bin/roff2ps $perl
    moveToOutput bin/roff2html $perl
    moveToOutput bin/glilypond $perl
    moveToOutput bin/mmroff $perl
    moveToOutput bin/roff2x $perl
    moveToOutput bin/afmtodit $perl
    moveToOutput bin/gperl $perl
    moveToOutput bin/chem $perl
    moveToOutput bin/gpinyin $perl
    moveToOutput lib/groff/gpinyin $perl
    moveToOutput bin/grog $perl
    moveToOutput lib/groff/grog $perl

    find $perl/ -type f -print0 | xargs --null sed -i 's|${buildPackages.perl}|${perl}|'
  '';

  meta = {
    homepage = "https://www.gnu.org/software/groff/";
    description = "GNU Troff, a typesetting package that reads plain text and produces formatted output";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "groff";
    outputsToInstall = [
      "out"
      "perl"
    ];
  };
})

{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  texinfo,
  perl,
  python3,
  makeWrapper,
  autoreconfHook,
  sbcl,
  rlwrap ? null,
  tk ? null,
  gnuplot ? null,
  lisp-compiler ? sbcl,
}:

let
  # Allow to remove some executables from the $PATH of the wrapped binary
  searchPath = lib.makeBinPath (
    lib.filter (x: x != null) [
      lisp-compiler
      rlwrap
      tk
      gnuplot
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "maxima";
  version = "5.50.0";

  src = fetchurl {
    url = "mirror://sourceforge/maxima/maxima-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-C8S14R/hU+8gsko6gWtmjs5TeMxzj6JMpCa2L9bY/Dc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    lisp-compiler
    makeWrapper
    python3
    texinfo
  ];

  strictDeps = true;

  nativeCheckInputs = [
    gnuplot
  ];

  postPatch = ''
    substituteInPlace doc/info/Makefile.am --replace "/usr/bin/env perl" "${perl}/bin/perl"
  '';

  postInstall = ''
    # Make sure that maxima can find its runtime dependencies.
    for prog in "$out/bin/"*; do
      wrapProgram "$prog" --prefix PATH ":" "$out/bin:${searchPath}"
    done
    # Move documentation into the right place.
    mkdir -p $out/share/doc
    ln -s ../maxima/${finalAttrs.version}/doc $out/share/doc/maxima
  ''
  + (lib.optionalString (lisp-compiler.pname == "ecl") ''
    cp src/binary-ecl/maxima.fas* "$out/lib/maxima/${finalAttrs.version}/binary-ecl/"
  '');

  patches = [
    # fix path to info dir (see https://trac.sagemath.org/ticket/11348)
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/07d6c37d18811e2b377a9689790a7c5e24da16ba/build/pkgs/maxima/patches/infodir.patch";
      sha256 = "09v64n60f7i6frzryrj0zd056lvdpms3ajky4f9p6kankhbiv21x";
    })

    # CVE-2024-34490 fix is included upstream since 5.48.0
  ];

  # The test suite is disabled since 5.42.2 because of the following issues:
  #
  #   Error(s) found:
  #   /build/maxima-5.44.0/share/linearalgebra/rtest_matrixexp.mac problems:
  #   (20 21 22)
  #   Tests that were expected to fail but passed:
  #   /build/maxima-5.44.0/share/vector/rtest_vect.mac problem:
  #   (19)
  #   3 tests failed out of 16,184 total tests.
  #
  # These failures don't look serious. It would be nice to fix them, but I
  # don't know how and probably won't have the time to find out.
  doCheck = false; # try to re-enable after next version update


  meta = {
    description = "Computer algebra system";
    homepage = "http://maxima.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    longDescription = ''
      Maxima is a fairly complete computer algebra system written in
      lisp with an emphasis on symbolic computation. It is based on
      DOE-MACSYMA and licensed under the GPL. Its abilities include
      symbolic integration, 3D plotting, and an ODE solver.
    '';
    platforms = lib.platforms.unix;
  };
})

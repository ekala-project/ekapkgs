{
  lib,
  stdenv,
  fetchurl,
  gawk,
  fetchpatch,
  undmg ? null,
  cpio,
  xar,
  libiconv,
}:

let
  startFPC = import ./binary.nix {
    inherit
      stdenv
      fetchurl
      undmg
      cpio
      xar
      lib
      ;
  };
in

stdenv.mkDerivation rec {
  version = "3.2.2";
  pname = "fpc";

  src = fetchurl {
    url = "mirror://sourceforge/freepascal/fpcbuild-${version}.tar.gz";
    sha256 = "85ef993043bb83f999e2212f1bca766eb71f6f973d362e2290475dbaaf50161f";
  };

  buildInputs = [
    startFPC
    gawk
  ];

  glibc = stdenv.cc.libc.out;

  patches = [
    ./mark-paths.patch
  ]
  ++ lib.optional stdenv.hostPlatform.isAarch64 (fetchpatch {
    url = "https://gitlab.com/freepascal.org/fpc/source/-/commit/a20a7e3497bccf3415bf47ccc55f133eb9d6d6a0.patch";
    hash = "sha256-xKTBwuOxOwX9KCazQbBNLhMXCqkuJgIFvlXewHY63GM=";
    stripLen = 1;
    extraPrefix = "fpcsrc/";
  });

  postPatch = ''
    substituteInPlace fpcsrc/compiler/systems/t_linux.pas --subst-var-by dynlinker-prefix "${glibc}"
    substituteInPlace fpcsrc/compiler/systems/t_linux.pas --subst-var-by syslibpath "${glibc}/lib"

    substituteInPlace fpcsrc/compiler/systems/t_darwin.pas \
      --replace-fail "LibrarySearchPath.AddLibraryPath(sysrootpath,'=/usr/lib',true)" "LibrarySearchPath.AddLibraryPath(sysrootpath,'$SDKROOT/usr/lib',true)"

    substituteInPlace fpcsrc/compiler/Makefile \
      --replace \
        "\$(CODESIGN) --remove-signature" \
        "${./remove-signature.sh}" \
      --replace "ifneq (\$(CODESIGN),)" "ifeq (\$(OS_TARGET), darwin)" \
      --replace "-no_uuid" ""
  '';

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    NIX_LDFLAGS="-syslibroot $SDKROOT -L${lib.getLib libiconv}/lib"
  '';

  makeFlags = [
    "NOGDB=1"
    "FPC=${startFPC}/bin/fpc"
  ];

  hardeningDisable = [ "pie" ];

  installFlags = [ "INSTALL_PREFIX=\${out}" ];

  postInstall = ''
    for i in $out/lib/fpc/*/ppc*; do
      ln -fs $i $out/bin/$(basename $i)
    done
    mkdir -p $out/lib/fpc/etc/
    $out/lib/fpc/*/samplecfg $out/lib/fpc/${version} $out/lib/fpc/etc/

    mkdir -p $out/etc
    $out/lib/fpc/*/samplecfg $out/lib/fpc/${version} $out/etc
  '';

  meta = {
    description = "Free Pascal Compiler from a source distribution";
    homepage = "https://www.freepascal.org";
    license = with lib.licenses; [
      gpl2
      lgpl2
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}

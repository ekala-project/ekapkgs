{
  lib,
  stdenv,
  fetchurl,
  help2man,
  pkg-config,
  texinfo,
  boehmgc,
  readline,
  nbdSupport ? true,
  libnbd ? null,
  textStylingSupport ? true,
  gettext,
  dejagnu,
}:

let
  isCross = stdenv.hostPlatform != stdenv.buildPlatform;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "poke";
  version = "4.3";

  src = fetchurl {
    url = "mirror://gnu/poke/poke-${finalAttrs.version}.tar.gz";
    hash = "sha256-qEy5F11Q1FpBHySB/QZiuDyzLOUXMWuInPtXCBlXk3M=";
  };

  outputs = [
    "out"
    "dev"
    "info"
    "lib"
  ]
  ++ lib.optional (!isCross) "man";

  postPatch = ''
    patchShebangs .
  '';

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    texinfo
  ]
  ++ lib.optionals (!isCross) [
    help2man
  ];

  buildInputs = [
    boehmgc
    readline
  ]
  ++ lib.optional (nbdSupport && libnbd != null) libnbd
  ++ lib.optional textStylingSupport gettext
  ++ lib.optional finalAttrs.finalPackage.doCheck dejagnu;

  configureFlags = [
    "--datadir=${placeholder "lib"}/share"
  ];

  enableParallelBuilding = true;

  doCheck = true;
  nativeCheckInputs = [ dejagnu ];

  postInstall = ''
    moveToOutput share/emacs "$out"
    moveToOutput share/vim "$out"
  '';

  meta = {
    description = "Interactive, extensible editor for binary data";
    homepage = "http://www.jemarch.net/poke";
    changelog = "https://git.savannah.gnu.org/cgit/poke.git/plain/NEWS?h=releases/poke-${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

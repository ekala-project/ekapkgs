{
  lib,
  stdenv,
  fetchurl,
  python3,
  bdftopcf,
  mkfontscale,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "terminus-font";
  version = "4.49.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/terminus-font/terminus-font-${lib.versions.majorMinor finalAttrs.version}/terminus-font-${finalAttrs.version}.tar.gz";
    hash = "sha256-2WHBt4Fie/QX+bNAaT1k/CGeAROtOjrxo0JMeqNz73k=";
  };

  patches = [ ./SOURCE_DATE_EPOCH-for-otb.patch ];

  nativeBuildInputs = [
    python3
    bdftopcf
    mkfontscale
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile --replace 'fc-cache' '#fc-cache'
    substituteInPlace Makefile --replace 'gzip'     'gzip -n'
  '';

  installTargets = [
    "install"
    "install-otb"
    "fontdir"
  ];
  enableParallelInstalling = false;

  meta = {
    description = "Clean fixed width font";
    homepage = "https://terminus-font.sourceforge.net/";
    license = lib.licenses.ofl;
  };
})

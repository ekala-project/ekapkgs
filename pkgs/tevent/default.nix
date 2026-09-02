{
  lib,
  stdenv,
  fetchurl,
  python3,
  pkg-config,
  cmocka,
  readline,
  talloc,
  libxslt,
  docbook-xsl-nons,
  docbook_xml_dtd_42,
  which,
  wafHook,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tevent";
  version = "0.17.1";

  src = fetchurl {
    url = "mirror://samba/tevent/tevent-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-G+LepzfN4l/gZiH4SUXmPrcSWeDEPp+PXaSC2rGnvpI=";
  };

  nativeBuildInputs = [
    pkg-config
    which
    python3
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    wafHook
  ];

  buildInputs = [
    python3
    cmocka
    readline
    talloc
    libxcrypt
  ];

  preConfigure = ''
    export PKGCONFIG="$PKG_CONFIG"
    export PYTHONHASHSEED=1
  '';

  wafPath = "buildtools/bin/waf";

  wafConfigureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  meta = {
    description = "Event system based on the talloc memory management library";
    homepage = "https://tevent.samba.org/";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.all;
  };
})

{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  python3,
  readline,
  libxslt,
  libxcrypt,
  docbook-xsl-nons,
  docbook_xml_dtd_45,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tdb";
  version = "1.4.15";

  src = fetchurl {
    url = "mirror://samba/tdb/tdb-${finalAttrs.version}.tar.gz";
    hash = "sha256-+6CdjfHxuQcq6ujniyvUPFr+8gsvbe76YzqhSjd6jdI=";
  };

  nativeBuildInputs = [
    python3
    pkg-config
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_45
  ];

  buildInputs = [
    python3
    readline
    libxcrypt
  ];

  preConfigure = ''
    export PKGCONFIG="$PKG_CONFIG"
    export PYTHONHASHSEED=1
    patchShebangs --build buildtools/bin/waf
  '';

  configurePhase = ''
    runHook preConfigure
    ./buildtools/bin/waf configure --prefix=$out \
      --bundled-libraries=NONE \
      --builtin-libraries=replace
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ./buildtools/bin/waf build -j $NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ./buildtools/bin/waf install -j $NIX_BUILD_CORES
    runHook postInstall
  '';

  postFixup =
    if stdenv.hostPlatform.isDarwin then
      "install_name_tool -id $out/lib/libtdb.dylib $out/lib/libtdb.dylib"
    else
      null;

  env = {
    PYTHON_CONFIG = "/invalid";
  }
  //
    lib.optionalAttrs (stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17")
      {
        NIX_LDFLAGS = "--undefined-version";
      };

  meta = {
    description = "Trivial database";
    homepage = "https://tdb.samba.org/";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.all;
  };
})

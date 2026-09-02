{
  lib,
  stdenv,
  fetchurl,
  python3,
  pkg-config,
  readline,
  libxslt,
  libxcrypt,
  docbook-xsl-nons,
  docbook_xml_dtd_42,
}:

stdenv.mkDerivation rec {
  pname = "talloc";
  version = "2.4.4";

  src = fetchurl {
    url = "mirror://samba/talloc/talloc-${version}.tar.gz";
    sha256 = "sha256-VeR5lAGME3Q0hVROcgZ4D/uzyElecEqZY2UD5ud6v1k=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
    docbook-xsl-nons
    docbook_xml_dtd_42
  ];

  buildInputs = [
    python3
    readline
    libxslt
    libxcrypt
  ];

  preConfigure = ''
    export PKGCONFIG="$PKG_CONFIG"
    export PYTHONHASHSEED=1
    patchShebangs --build buildtools/bin/waf
  '';

  configurePhase = ''
    runHook preConfigure

    ./buildtools/bin/waf configure \
      --prefix=$out \
      --enable-talloc-compat1 \
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

  postInstall = ''
    ${stdenv.cc.targetPrefix}ar q $out/lib/libtalloc.a bin/default/talloc.c.[0-9]*.o
  '';

  env = {
    PYTHON_CONFIG = "/invalid";
  };

  preBuild = lib.optionalString stdenv.hostPlatform.isMusl ''
    export NIX_CFLAGS_LINK="-no-pie -shared";
  '';

  meta = {
    description = "Hierarchical pool based memory allocator with destructors";
    homepage = "https://tdb.samba.org/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}

{
  stdenv,
  lib,
  fetchurl,
  buildPackages,
  pkg-config,
  freetype,
  harfbuzz,
  openjpeg,
  jbig2dec,
  libjpeg,
  gumbo,
  enableCurl ? true,
  curl,
  openssl,
}:

stdenv.mkDerivation rec {
  version = "1.25.3";
  pname = "mupdf";

  src = fetchurl {
    url = "https://mupdf.com/downloads/archive/${pname}-${version}-source.tar.gz";
    hash = "sha256-uXTXBqloBTPRBLQRIiTHvz3pPye+fKQbS/tRVSYk8Kk=";
  };

  postPatch = ''
    substituteInPlace Makerules --replace "(shell pkg-config" "(shell $PKG_CONFIG"
  '';

  makeFlags = [
    "prefix=$(out)"
    "shared=yes"
    "USE_SYSTEM_LIBS=yes"
    "HAVE_X11=no"
    "HAVE_GLUT=no"
    "PKG_CONFIG=${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    freetype
    harfbuzz
    openjpeg
    jbig2dec
    libjpeg
    gumbo
  ]
  ++ lib.optionals enableCurl [
    curl
    openssl
  ];

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "doc"
  ];

  preConfigure = ''
    rm -rf thirdparty/{curl,freetype,glfw,harfbuzz,jbig2dec,libjpeg,openjpeg,zlib}
  '';

  postInstall = ''
    mkdir -p "$out/lib/pkgconfig"
    cat >"$out/lib/pkgconfig/mupdf.pc" <<EOF
    prefix=$out
    libdir=''${prefix}/lib
    includedir=''${prefix}/include

    Name: mupdf
    Description: Library for rendering PDF documents
    Version: ${version}
    Libs: -L''${libdir} -lmupdf
    Cflags: -I''${includedir}
    EOF

    moveToOutput "bin" "$bin"
  '';

  enableParallelBuilding = true;

  env.USE_SONAME = "no";

  meta = {
    homepage = "https://mupdf.com";
    description = "Lightweight PDF, XPS, and E-book viewer and toolkit written in portable C";
    changelog = "https://git.ghostscript.com/?p=mupdf.git;a=blob_plain;f=CHANGES;hb=${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "mutool";
  };
}

{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  buildPackages,
  pkg-config,
  freetype,
  harfbuzz,
  openjpeg,
  jbig2dec,
  libjpeg,
  gumbo,
  enableX11 ? true,
  libX11,
  libXext,
  libXi,
  libXrandr,
  enableCurl ? true,
  curl,
  openssl,
  enableGL ? true,
  freeglut,
  libGLU,
}:

let
  freeglut-mupdf = freeglut.overrideAttrs (old: rec {
    pname = "freeglut-mupdf";
    version = "3.0.0-r${src.rev}";
    src = fetchFromGitHub {
      owner = "ArtifexSoftware";
      repo = "thirdparty-freeglut";
      rev = "13ae6aa2c2f9a7b4266fc2e6116c876237f40477";
      hash = "sha256-0fuE0lm9rlAaok2Qe0V1uUrgP4AjMWgp3eTbw8G6PMM=";
    };
  });
in

stdenv.mkDerivation rec {
  version = "1.25.3";
  pname = "mupdf";

  src = fetchurl {
    url = "https://mupdf.com/downloads/archive/${pname}-${version}-source.tar.gz";
    hash = "sha256-uXTXBqloBTPRBLQRIiTHvz3pPye+fKQbS/tRVSYk8Kk=";
  };

  patches = [
    ./fix-darwin-system-deps.patch
  ];

  postPatch = ''
    substituteInPlace Makerules --replace "(shell pkg-config" "(shell $PKG_CONFIG"
  '';

  makeFlags = [
    "prefix=$(out)"
    "shared=yes"
    "USE_SYSTEM_LIBS=yes"
    "PKG_CONFIG=${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config"
  ]
  ++ lib.optionals (!enableX11) [ "HAVE_X11=no" ]
  ++ lib.optionals (!enableGL) [ "HAVE_GLUT=no" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    freetype
    harfbuzz
    openjpeg
    jbig2dec
    libjpeg
    gumbo
  ]
  ++ lib.optionals enableX11 [
    libX11
    libXext
    libXi
    libXrandr
  ]
  ++ lib.optionals enableCurl [
    curl
    openssl
  ]
  ++ lib.optionals enableGL [
    freeglut-mupdf
    libGLU
  ];

  outputs = [ "bin" "dev" "out" "man" "doc" ];

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
  '' + (lib.optionalString (enableX11 || enableGL) ''
    mkdir -p $bin/share/icons/hicolor/48x48/apps
    cp docs/logo/mupdf-icon-48.png $bin/share/icons/hicolor/48x48/apps
  '') + (
    if enableGL then ''
      ln -s "$bin/bin/mupdf-gl" "$bin/bin/mupdf"
    '' else lib.optionalString enableX11 ''
      ln -s "$bin/bin/mupdf-x11" "$bin/bin/mupdf"
    ''
  );

  enableParallelBuilding = true;

  env.USE_SONAME = "no";

  meta = {
    homepage = "https://mupdf.com";
    description = "Lightweight PDF, XPS, and E-book viewer and toolkit written in portable C";
    changelog = "https://git.ghostscript.com/?p=mupdf.git;a=blob_plain;f=CHANGES;hb=${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "mupdf";
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  dav1d,
  libde265,
  x265,
  libpng,
  libjpeg,
  gdk-pixbuf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libheif";
  version = "1.23.1";

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libheif";
    rev = "v${finalAttrs.version}";
    hash = "sha256-o+gQCv/lpRx+IaqpjHACh8ysgl/N4Mo/9zbAI/cnWas=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    dav1d
    libde265
    x265
    libpng
    libjpeg
    gdk-pixbuf
  ];

  cmakeFlags = [
    "-DWITH_AOM_DECODER=OFF"
    "-DWITH_AOM_ENCODER=OFF"
  ];

  env.PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${placeholder "lib"}/${gdk-pixbuf.moduleDir}";

  postInstall = ''
    substituteInPlace $out/share/thumbnailers/heif.thumbnailer \
      --replace-fail "TryExec=heif-thumbnailer" "TryExec=$bin/bin/heif-thumbnailer" \
      --replace-fail "Exec=heif-thumbnailer" "Exec=$bin/bin/heif-thumbnailer"
  '';

  postFixup = ''
    sed '/^  INTERFACE_INCLUDE_DIRECTORIES/s|"[^"]*/include"|"${placeholder "dev"}/include"|' \
      -i "$dev"/lib/cmake/libheif/libheif-config.cmake
  '';

  meta = {
    homepage = "http://www.libheif.org/";
    description = "ISO/IEC 23008-12:2017 HEIF image file format decoder and encoder";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})

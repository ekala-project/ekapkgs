{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  cargo,
  rustc,
  boost,
  gdk-pixbuf,
  glib,
  libjpeg,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "libopenraw";
  version = "0.3.7";

  src = fetchurl {
    url = "https://libopenraw.freedesktop.org/download/libopenraw-${version}.tar.bz2";
    hash = "sha256-VRWyYQNh7zRYC2uXZjURn23ttPCnnVRmL6X+YYakXtU=";
  };

  nativeBuildInputs = [
    pkg-config
    cargo
    rustc
  ];

  buildInputs = [
    boost
    gdk-pixbuf
    glib
    libjpeg
    libxml2
  ];

  configureFlags = [
    "--with-boost=${boost.dev}"
  ];

  postPatch = ''
    sed -i configure{,.ac} \
      -e "s,GDK_PIXBUF_DIR=.*,GDK_PIXBUF_DIR=$out/lib/gdk-pixbuf-2.0/2.10.0/loaders,"
  '';

  meta = {
    description = "RAW camerafile decoding library";
    homepage = "https://libopenraw.freedesktop.org";
    license = lib.licenses.lgpl3Plus;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}

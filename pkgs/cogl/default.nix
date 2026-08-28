{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libGL,
  glib,
  gdk-pixbuf,
  xorg,
  pango,
  cairo,
  wayland,
  libgbm,
  mesa-gl-headers,
  automake,
  autoconf,
  harfbuzz,
}:

stdenv.mkDerivation rec {
  pname = "cogl";
  version = "1.22.8";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/cogl-${version}.tar.xz";
    sha256 = "0nfph4ai60ncdx7hy6hl1i1cmp761jgnyjfhagzi0iqq36qb41d8";
  };

  patches = [
    ./patches/gnome_bugzilla_787443_359589_deepin.patch
    ./patches/gnome_bugzilla_787443_361056_deepin.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    automake
    autoconf
  ];

  configureFlags = [
    "--disable-introspection"
    "--enable-kms-egl-platform"
    "--enable-wayland-egl-platform"
    "--enable-wayland-egl-server"
    "--enable-gles1"
    "--enable-gles2"
    "LIBS=-lGL"
  ];

  propagatedBuildInputs = [
    glib
    gdk-pixbuf
    wayland
    libgbm
    mesa-gl-headers
    libGL
    xorg.libXrandr
    xorg.libXfixes
    xorg.libXcomposite
    xorg.libXdamage
  ];

  buildInputs = [
    pango
    cairo
    harfbuzz
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  meta = {
    description = "Small open source library for using 3D graphics hardware for rendering";
    homepage = "https://gitlab.gnome.org/GNOME/cogl";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      mit
      bsd3
      publicDomain
      sgi-b-20
    ];
  };
}

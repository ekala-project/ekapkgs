{
  lib,
  stdenv,
  fetchFromGitHub,
  docbook-xml-dtd,
  docbook-xsl-nons,
  glib,
  gobject-introspection,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  python3,
  shared-mime-info,
  xz,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "libxmlb";
  version = "0.3.29";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libxmlb";
    rev = version;
    hash = "sha256-4Y49Jd3KkEfbZ0ObLGG/e0xkJ1MfyfAnhiKZgLOEFsw=";
  };

  nativeBuildInputs = [
    docbook-xml-dtd.v4_3
    docbook-xsl-nons
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    shared-mime-info
    gobject-introspection
    gtk-doc
  ];

  buildInputs = [
    glib
    xz
    zstd
  ];

  mesonEntries = {
    gtkdoc = false;
    introspection = true;
    tests = false;
  };

  mesonFlags = [
    "--libexecdir=${placeholder "
    out"}/libexec"
  ];

  doCheck = false;

  meta = {
    description = "Library to help create and query binary XML blobs";
    mainProgram = "xb-tool";
    homepage = "https://github.com/hughsie/libxmlb";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}

{
  stdenv,
  lib,
  docbook-xsl-nons,
  fetchurl,
  glib,
  gobject-introspection,
  gtk-doc,
  libpcap,
  meson,
  ninja,
  pkg-config,
  replaceVars,
  systemdMinimal,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "umockdev";
  version = "0.20.0";

  outputs = [
    "bin"
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "https://github.com/martinpitt/umockdev/releases/download/${finalAttrs.version}/umockdev-${finalAttrs.version}.tar.xz";
    hash = "sha256-xuokbEV9KdWJLGYiv0gSc3rul1FTSX80YsVy5hsEBL4=";
  };

  patches = [
    ./hardcode-paths.patch

    (replaceVars ./substitute-udevadm.patch {
      udevadm = "${systemdMinimal}/bin/udevadm";
    })
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    gobject-introspection
    gtk-doc
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    systemdMinimal
    libpcap
  ];

  strictDeps = true;

  mesonEntries = {
    gtk_doc = true;
  };

  postPatch = ''
    substituteInPlace src/umockdev-wrapper \
      --subst-var-by 'LIBDIR' "''${!outputLib}/lib"
  ''
  + lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace src/libumockdev-preload.c \
      --replace-fail libc.so.6 libc.so
  '';

  preCheck = ''
    mkdir -p "$out/lib"
    ln -s "$PWD/libumockdev-preload.so.0" "$out/lib/libumockdev-preload.so.0"
  '';

  meta = {
    homepage = "https://github.com/martinpitt/umockdev";
    description = "Mock hardware devices for creating unit tests";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})

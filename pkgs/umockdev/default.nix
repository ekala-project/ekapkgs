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
  version = "0.19.8";

  outputs = [
    "bin"
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "https://github.com/martinpitt/umockdev/releases/download/${finalAttrs.version}/umockdev-${finalAttrs.version}.tar.xz";
    hash = "sha256-nVfJF6MtxpaHerUl61EJcagQmJnVuS2YbnusMlcxJbA=";
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

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  doCheck = false;

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

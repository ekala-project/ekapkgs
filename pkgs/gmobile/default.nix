{
  lib,
  stdenv,
  fetchFromGitLab,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  glib,
  json-glib,
  libuev,
  gobject-introspection,
  udevCheckHook,
  vala,
  fetchpatch2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmobile";
  version = "0.7.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = "gmobile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RXkH+48WzACgNcIROlSTSO4l/ujWVHJDG+Xtk4k7Rdw=";
  };

  patches = [
    (fetchpatch2 {
      name = "dont-set-libexecdir.patch";
      url = "https://gitlab.gnome.org/World/Phosh/gmobile/-/commit/b085e13898edddf31b6da8c8fc4119bb2cb59c38.patch";
      hash = "sha256-S3S1FORPC8czFx0ivLVOUhamStaJsKd6oXnh1jbdr3Y=";
    })
  ];

  nativeBuildInputs = [
    gtk-doc
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gobject-introspection
    udevCheckHook
    vala
  ];

  buildInputs = [
    glib
    json-glib
    libuev
  ];
  strictDeps = true;

  meta = {
    description = "Functions useful in mobile related, glib based projects";
    homepage = "https://gitlab.gnome.org/World/Phosh/gmobile";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})

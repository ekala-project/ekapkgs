{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  gettext,
  vala,
  gobject-introspection,
  libcap_ng,
  libvirt,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvirt-glib";
  version = "5.0.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://libvirt.org/sources/glib/libvirt-glib-${finalAttrs.version}.tar.xz";
    sha256 = "m/7DRjgkFqNXXYcpm8ZBsqRkqlGf2bEofjGKpDovO4s=";
  };

  patches = [
    (fetchpatch {
      name = "relax-max-stack-size-limit.patch";
      url = "https://gitlab.com/libvirt/libvirt-glib/-/commit/062f21ccaa810087637ae24e0eb69f1a0f0a45f5.patch";
      hash = "sha256-6mvINDd1HYS7oZsyNiyEwdNJfK5I5nPx86TRMq2RevA=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    libvirt
    libxml2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap_ng
  ];

  mesonFlags = [
    "-Ddocs=disabled"
  ];

  meta = {
    description = "Wrapper library of libvirt for glib-based applications";
    homepage = "https://libvirt.org/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})

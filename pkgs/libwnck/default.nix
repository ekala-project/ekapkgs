{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  libx11,
  glib,
  gtk3,
  pango,
  cairo,
  libxres,
  libxi,
  libstartup_notification,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwnck";
  version = "43.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libwnck/${lib.versions.major finalAttrs.version}/libwnck-${finalAttrs.version}.tar.xz";
    sha256 = "avisQajwZ63h08qu0lSoNCO19hrT96Rg/Ky6wuGSvfc=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
  ];

  buildInputs = [
    libx11
    libstartup_notification
    pango
    cairo
    libxres
    libxi
  ];

  propagatedBuildInputs = [
    glib
    gtk3
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    (lib.mesonEnable "introspection" false)
  ];

  meta = {
    description = "Library to manage X windows and workspaces (via pagers, tasklists, etc.)";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})

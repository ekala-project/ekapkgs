{
  stdenv,
  lib,
  fetchurl,
  cmake,
  gettext,
  intltool,
  pkg-config,
  evolution-data-server,
  evolution,
  gtk3,
  libsoup_3,
  libical,
  json-glib,
  libmspack,
  webkitgtk_4_1,
  replaceVars,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "evolution-ews";
  version = "3.60.2";

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-ews/${lib.versions.majorMinor finalAttrs.version}/evolution-ews-${finalAttrs.version}.tar.xz";
    hash = "sha256-lAIFgY9piEEUV931gE0hDzUVwm4zQV3r2Puycxsdrys=";
  };

  patches = [
    # evolution-ews contains .so files loaded by evolution-data-server referring
    # schemas from evolution. evolution-data-server is not wrapped with
    # evolution's schemas because it would be a circular dependency with
    # evolution.
    (replaceVars ./hardcode-gsettings.patch {
      evo = glib.makeSchemaPath evolution evolution.name;
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gettext
    intltool
    pkg-config
  ];

  buildInputs = [
    evolution-data-server
    evolution
    gtk3
    libsoup_3
    libical
    json-glib
    libmspack
    # For evolution-shell-3.0
    webkitgtk_4_1
  ];

  cmakeEntries = {
    # don't try to install into ${evolution}
    FORCE_INSTALL_PREFIX = true;
  };

  meta = {
    description = "Evolution connector for Microsoft Exchange Server protocols";
    homepage = "https://gitlab.gnome.org/GNOME/evolution-ews";
    license = lib.licenses.lgpl21Plus; # https://gitlab.gnome.org/GNOME/evolution-ews/issues/111
    platforms = lib.platforms.linux;
  };
})

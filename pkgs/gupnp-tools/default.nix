{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  gupnp_1_6,
  libsoup_3,
  gssdp_1_6,
  pkg-config,
  gtk3,
  gettext,
  gupnp-av,
  gtksourceview4,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gupnp-tools";
  version = "0.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-tools/${lib.versions.majorMinor finalAttrs.version}/gupnp-tools-${finalAttrs.version}.tar.xz";
    sha256 = "TJLy0aPUVOwfX7Be8IyjTfnHQ69kyLWWXDWITUbLAFw=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    gupnp_1_6
    libsoup_3
    gssdp_1_6
    gtk3
    gupnp-av
    gtksourceview4
  ];

  mesonFlags = [
    # Work around https://gitlab.gnome.org/GNOME/gupnp-tools/-/issues/29
    "-Dc_args=-Wno-error=deprecated-declarations"
  ];

  meta = {
    description = "Set of utilities and demos to work with UPnP";
    homepage = "https://gitlab.gnome.org/GNOME/gupnp-tools";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})

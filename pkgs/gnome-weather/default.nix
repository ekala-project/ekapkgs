{
  lib,
  stdenv,
  fetchurl,
  desktop-file-utils ? null,
  pkg-config,
  adwaita-icon-theme ? null,
  gtk4,
  libadwaita ? null,
  wrapGAppsHook4 ? null,
  gjs ? null,
  gobject-introspection,
  libgweather ? null,
  meson,
  ninja,
  geoclue2 ? null,
  python3,
  gsettings-desktop-schemas,
  typescript ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-weather";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-weather/${lib.versions.major finalAttrs.version}/gnome-weather-${finalAttrs.version}.tar.xz";
    hash = "sha256-V951eGBfkfmrQAVRznc423UFvIj0KjPHDOenAWf9tRM=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    pkg-config
    meson
    ninja
    wrapGAppsHook4
    python3
    gobject-introspection
    gjs
    typescript
  ];

  buildInputs = [
    gtk4
    libadwaita
    gjs
    libgweather
    adwaita-icon-theme
    geoclue2
    gsettings-desktop-schemas
  ];

  postPatch = ''
    substituteInPlace "data/org.gnome.Weather.service.in" \
        --replace-fail "Exec=@DATA_DIR@/@APP_ID@" "Exec=$out/bin/gnome-weather"

    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  meta = {
    homepage = "https://apps.gnome.org/Weather/";
    description = "Access current weather conditions and forecasts";
    mainProgram = "gnome-weather";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})

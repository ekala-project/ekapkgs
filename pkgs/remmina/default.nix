{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  curl,
  fuse3,
  glib,
  gtk3,
  gettext,
  libxkbfile,
  libx11,
  python3,
  freerdp ? null,
  libssh,
  libgcrypt,
  gnutls,
  pcre2,
  libdbusmenu-gtk3,
  libappindicator-gtk3,
  libvncserver,
  libpthread-stubs,
  libxdmcp,
  libxkbcommon,
  libsecret,
  libsoup_3,
  spice-protocol ? null,
  spice-gtk ? null,
  libepoxy,
  at-spi2-core,
  openssl,
  gsettings-desktop-schemas,
  json-glib,
  libsodium,
  harfbuzz,
  wayland,
  # The themes here are soft dependencies; only icons are missing without them.
  adwaita-icon-theme,
  withLibsecret ? stdenv.hostPlatform.isLinux,
  withWebkitGtk ? false,
  webkitgtk_4_1 ? null,
  withVte ? true,
  vte,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "remmina";
  version = "1.4.43";

  src = fetchFromGitLab {
    owner = "Remmina";
    repo = "Remmina";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7nY2NhlWp+4FTTmeam1B+sotqis0lSwhozSC8I14aMI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    curl
    gsettings-desktop-schemas
    glib
    gtk3
    gettext
    libxkbfile
    libx11
    libssh
    libgcrypt
    gnutls
    pcre2
    libvncserver
    libpthread-stubs
    libxdmcp
    libxkbcommon
    libsoup_3
    libepoxy
    at-spi2-core
    openssl
    adwaita-icon-theme
    json-glib
    libsodium
    harfbuzz
    python3
  ]
  ++ lib.optionals (freerdp != null) [ freerdp ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    fuse3
    libappindicator-gtk3
    libdbusmenu-gtk3
    wayland
  ]
  ++ lib.optionals (spice-protocol != null) [ spice-protocol ]
  ++ lib.optionals (spice-gtk != null) [ spice-gtk ]
  ++ lib.optionals withLibsecret [ libsecret ]
  ++ lib.optionals (withWebkitGtk && webkitgtk_4_1 != null) [ webkitgtk_4_1 ]
  ++ lib.optionals withVte [ vte ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  cmakeFlags = [
    "-DWITH_FREERDP3=${if freerdp != null then "ON" else "OFF"}"
    "-DWITH_VTE=${if withVte then "ON" else "OFF"}"
    "-DWITH_TELEPATHY=OFF"
    "-DWITH_AVAHI=OFF"
    "-DWITH_LIBSECRET=${if withLibsecret then "ON" else "OFF"}"
    "-DWITH_WEBKIT2GTK=${if withWebkitGtk && webkitgtk_4_1 != null then "ON" else "OFF"}"
  ];

  dontWrapQtApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --set-default SSL_CERT_DIR "/etc/ssl/certs/"
      --prefix LD_LIBRARY_PATH : "${libx11.out}/lib"
      --prefix PATH : "${lib.makeBinPath [ python3 ]}"
    )
  '';

  meta = {
    license = lib.licenses.gpl2Plus;
    homepage = "https://gitlab.com/Remmina/Remmina";
    description = "Remote desktop client written in GTK";
    mainProgram = "remmina";
    platforms = lib.platforms.linux;
  };
})

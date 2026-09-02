{
  stdenv,
  lib,
  buildPackages,
  fetchurl,
  pkg-config,
  python3,
  gobject-introspection,
  gettext,
  libsoup_3,
  libxml2,
  libsecret,
  icu,
  sqlite,
  libcanberra-gtk3 ? null,
  p11-kit,
  db ? null, # TODO: db (Berkeley DB) may need to be ported to ekapkgs
  nspr,
  nss ? null, # TODO: nss may need to be ported to ekapkgs
  libical, # TODO: libical is being ported; verify it is available
  gperf,
  wrapGAppsHook3,
  glib-networking,
  gsettings-desktop-schemas,
  vala,
  cmake,
  ninja,
  libkrb5 ? null, # TODO: libkrb5 (krb5) may need to be ported to ekapkgs
  openldap ? null, # TODO: openldap may need to be ported to ekapkgs
  enableOAuth2 ? stdenv.hostPlatform.isLinux,
  # TODO: webkitgtk_4_1 is not available in ekapkgs; OAuth2 with GTK3 will be disabled
  # webkitgtk_4_1,
  # TODO: webkitgtk_6_0 is not available in ekapkgs; OAuth2 with GTK4 will be disabled
  # webkitgtk_6_0,
  json-glib,
  glib,
  gtk3,
  gtk4,
  withGtk3 ? true,
  withGtk4 ? false,
  libphonenumber,
  libuuid ? null, # TODO: libuuid may need to be ported to ekapkgs
  gnome-online-accounts, # TODO: gnome-online-accounts is being ported; verify it is available
  libgweather,
  boost ? null, # TODO: boost may need to be ported to ekapkgs
  protobuf ? null, # TODO: protobuf may need to be ported to ekapkgs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "evolution-data-server";
  version = "3.60.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/${lib.versions.majorMinor finalAttrs.version}/evolution-data-server-${finalAttrs.version}.tar.xz";
    hash = "sha256-IITb2sOWNxs2XVBMH/RYZrqNyi8SUuXaHT2cM6vcEoY=";
  };

  patches = [
    # Avoid using wrapper function, which the hardcode gsettings
    # patch generator cannot handle.
    ./drop-tentative-settings-constructor.patch
  ];

  prePatch = ''
    substitute ${./hardcode-gsettings.patch} hardcode-gsettings.patch \
      --subst-var-by EDS ${glib.makeSchemaPath "$out" "evolution-data-server-${finalAttrs.version}"} \
      --subst-var-by GDS ${glib.getSchemaPath gsettings-desktop-schemas}
    patches="$patches $PWD/hardcode-gsettings.patch"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    gettext
    python3
    gperf
    wrapGAppsHook3
    gobject-introspection
    vala
  ];

  buildInputs = [
    glib
    libsecret
    libsoup_3
    gnome-online-accounts
    p11-kit
    libgweather
    icu
    sqlite
    glib-networking
    libphonenumber
  ]
  ++ lib.optional (libkrb5 != null) libkrb5
  ++ lib.optional (openldap != null) openldap
  ++ lib.optional (libcanberra-gtk3 != null) libcanberra-gtk3
  ++ lib.optional (libuuid != null) libuuid
  ++ lib.optional (boost != null) boost
  ++ lib.optional (protobuf != null) protobuf
  ++ lib.optionals withGtk3 [
    gtk3
  ]
  # TODO: webkitgtk is not available in ekapkgs; OAuth2 support is disabled
  # ++ lib.optionals (withGtk3 && enableOAuth2) [
  #   webkitgtk_4_1
  # ]
  ++ lib.optionals withGtk4 [
    gtk4
  ];
  # TODO: webkitgtk is not available in ekapkgs; OAuth2 support is disabled
  # ++ lib.optionals (withGtk4 && enableOAuth2) [
  #   webkitgtk_6_0
  # ];

  propagatedBuildInputs = [
    nspr
    libical
    libsoup_3
    libxml2
    json-glib
  ]
  ++ lib.optional (db != null) db
  ++ lib.optional (nss != null) nss;

  cmakeFlags = [
    "-DENABLE_VALA_BINDINGS=ON"
    "-DENABLE_INTROSPECTION=ON"
    "-DINCLUDE_INSTALL_DIR=${placeholder "dev"}/include"
    "-DWITH_PHONENUMBER=ON"
    "-DENABLE_GTK=${lib.boolToString withGtk3}"
    "-DENABLE_EXAMPLES=${lib.boolToString withGtk3}"
    "-DENABLE_CANBERRA=${lib.boolToString (withGtk3 && libcanberra-gtk3 != null)}"
    "-DENABLE_GTK4=${lib.boolToString withGtk4}"
    # TODO: OAuth2 disabled because webkitgtk is not available in ekapkgs
    "-DENABLE_OAUTH2_WEBKITGTK=OFF"
    "-DENABLE_OAUTH2_WEBKITGTK4=OFF"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    (lib.cmakeFeature "CMAKE_CROSSCOMPILING_EMULATOR" (stdenv.hostPlatform.emulator buildPackages))
  ];

  strictDeps = true;

  postPatch = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace src/addressbook/libebook-contacts/CMakeLists.txt --replace-fail \
      'COMMAND ''${CMAKE_CURRENT_BINARY_DIR}/gen-western-table' \
      'COMMAND ${stdenv.hostPlatform.emulator buildPackages} ''${CMAKE_CURRENT_BINARY_DIR}/gen-western-table'
    substituteInPlace src/camel/CMakeLists.txt --replace-fail \
      'COMMAND ''${CMAKE_CURRENT_BINARY_DIR}/camel-gen-tables' \
      'COMMAND ${stdenv.hostPlatform.emulator buildPackages} ''${CMAKE_CURRENT_BINARY_DIR}/camel-gen-tables'
  '';

  meta = {
    description = "Unified backend for programs that work with contacts, tasks, and calendar information";
    homepage = "https://gitlab.gnome.org/GNOME/evolution-data-server";
    changelog = "https://gitlab.gnome.org/GNOME/evolution-data-server/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})

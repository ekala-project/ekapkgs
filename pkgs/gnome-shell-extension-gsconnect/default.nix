# GSConnect - manually packaged extension (built from source, not from extensions.gnome.org)
{
  stdenv,
  lib,
  fetchFromGitHub,
  replaceVars,
  openssl,
  gsound,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  glib,
  glib-networking,
  gtk3,
  openssh,
  gnome-shell,
  evolution-data-server-gtk4,
  gjs,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-gsconnect";
  version = "72";

  src = fetchFromGitHub {
    owner = "GSConnect";
    repo = "gnome-shell-extension-gsconnect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w9MQVEUQUcO1lqftBi76w5xSTlryKuZJxE6Ogg1J+ho=";
  };

  patches = [
    # Make typelibs available in the extension
    (replaceVars ./fix-paths.patch {
      gapplication = "${glib.bin}/bin/gapplication";
      gjs = "${gjs}/bin/gjs";
      # Replaced in postPatch
      typelibPath = null;
    })

    # Allow installing installed tests to a separate output
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gobject-introspection # for locating typelibs
    gtk3.wrapGAppsHook # for wrapping daemons
    desktop-file-utils # update-desktop-database
  ];

  buildInputs = [
    glib # libgobject
    glib-networking
    gtk3
    gsound
    gjs # for running daemon
    evolution-data-server-gtk4 # for libebook-contacts typelib
  ];

  mesonEntries = {
    gnome_shell_libdir = "${gnome-shell}/lib";
    chrome_nmhdir = "${placeholder "out"}/etc/opt/chrome/native-messaging-hosts";
    chromium_nmhdir = "${placeholder "out"}/etc/chromium/native-messaging-hosts";
    openssl_path = "${openssl}/bin/openssl";
    sshadd_path = "${openssh}/bin/ssh-add";
    sshkeygen_path = "${openssh}/bin/ssh-keygen";
    session_bus_services_dir = "${placeholder "out"}/share/dbus-1/services";
    installed_test_prefix = "${placeholder "out"}";
  };

  postPatch = ''
    patchShebangs installed-tests/prepare-tests.sh

    # TODO: do not include every typelib everywhere
    substituteInPlace src/__nix-prepend-search-paths.js \
      --subst-var-by typelibPath "$GI_TYPELIB_PATH"

    # slightly janky fix for gsettings_schemadir being removed
    substituteInPlace data/config.js.in \
      --subst-var-by GSETTINGS_SCHEMA_DIR \
        ${glib.makeSchemaPath (placeholder "out") "${finalAttrs.pname}-${finalAttrs.version}"}
  '';

  postFixup = ''
    # Let's wrap the daemons
    for file in $out/share/gnome-shell/extensions/gsconnect@andyholmes.github.io/service/{daemon,nativeMessagingHost}.js; do
      echo "Wrapping program $file"
      wrapGApp "$file"
    done
  '';

  passthru = {
    extensionUuid = "gsconnect@andyholmes.github.io";
    extensionPortalSlug = "gsconnect";
  };

  meta = {
    description = "KDE Connect implementation for Gnome Shell";
    homepage = "https://github.com/GSConnect/gnome-shell-extension-gsconnect/wiki";
    changelog = "https://github.com/GSConnect/gnome-shell-extension-gsconnect/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})

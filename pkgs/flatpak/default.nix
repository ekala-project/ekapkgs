{
  lib,
  stdenv,
  appstream,
  bison,
  bubblewrap,
  buildPackages,
  bzip2,
  coreutils,
  curl,
  dconf,
  desktop-file-utils,
  docbook-xsl-nons,
  docbook_xml_dtd_45,
  fetchurl,
  fuse3,
  gdk-pixbuf,
  gettext,
  glib,
  glib-networking,
  gobject-introspection,
  gpgme,
  gsettings-desktop-schemas,
  gtk-doc ? null,
  gtk3,
  hicolor-icon-theme,
  json-glib,
  libarchive,
  libcap,
  librsvg,
  libseccomp,
  libxml2,
  libxslt,
  meson,
  ninja,
  ostree,
  p11-kit,
  pkg-config,
  polkit,
  python3,
  runCommand,
  shared-mime-info,
  socat,
  replaceVars,
  systemd,
  validatePkgConfig,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wrapGAppsNoGuiHook,
  xdg-dbus-proxy,
  xmlto,
  libxau,
  zstd,
  withAutoSideloading ? false,
  withDconf ? true,
  withDocbookDocs ? true,
  withGlibNetworking ? true,
  withGtkDoc ? false,
  withIntrospection ? true,
  withMan ? withDocbookDocs,
  withP11Kit ? true,
  withPolkit ? true,
  withSELinuxModule ? false,
  withSystemd ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flatpak";
  version = "1.18.0";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDocbookDocs [
    "doc"
  ]
  ++ lib.optionals withGtkDoc [
    "devdoc"
  ]
  ++ lib.optional withMan "man";

  src = fetchurl {
    url = "https://github.com/flatpak/flatpak/releases/download/${finalAttrs.version}/flatpak-${finalAttrs.version}.tar.xz";
    hash = "sha256-pYV6ZsQDndoF2SvcsrAz14jNJYlhAWfw7F8OyNT6xvI=";
  };

  patches = [
    ./binary-path.patch
    ./fix-fonts-icons.patch
    ./unset-env-vars.patch
    ./flatpak-spawn-env.patch

    (replaceVars ./fix-icon-validation.patch {
      inherit (builtins) storeDir;
    })
  ]
  ++ lib.optionals withP11Kit [
    (replaceVars ./fix-paths.patch {
      p11kit = lib.getExe p11-kit;
    })
  ];

  postPatch = ''
    patchShebangs buildutil/ tests/
    patchShebangs --build subprojects/variant-schema-compiler/variant-schema-compiler

    substituteInPlace doc/meson.build \
      --replace-fail '$MESON_INSTALL_DESTDIR_PREFIX/@1@/@2@' '@1@/@2@'

    substituteInPlace triggers/gtk-icon-cache.trigger \
      --replace-fail '/usr/share/icons/hicolor/index.theme' '/run/current-system/sw/share/icons/hicolor/index.theme'
  '';

  postInstall = ''
    wrapProgram $out/share/flatpak/triggers/desktop-database.trigger --prefix PATH : ${
      lib.makeBinPath [
        desktop-file-utils
      ]
    }

    wrapProgram $out/share/flatpak/triggers/gtk-icon-cache.trigger --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        gtk3
      ]
    }

    wrapProgram $out/share/flatpak/triggers/mime-database.trigger --prefix PATH : ${
      lib.makeBinPath [
        shared-mime-info
      ]
    }
  '';

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    (python3.pythonOnBuildForHost.withPackages (p: [ p.pyparsing ]))
    bison
    glib
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    validatePkgConfig
    wayland-scanner
    wrapGAppsNoGuiHook
  ]
  ++ lib.optional (withGtkDoc && gtk-doc != null) gtk-doc
  ++ lib.optional withIntrospection gobject-introspection
  ++ lib.optional withMan libxslt
  ++ lib.optional withSELinuxModule bzip2
  ++ lib.optionals withDocbookDocs [
    docbook-xsl-nons
    docbook_xml_dtd_45
    xmlto
  ];

  buildInputs = [
    appstream
    curl
    fuse3
    gdk-pixbuf
    gpgme
    gsettings-desktop-schemas
    json-glib
    libarchive
    libcap
    librsvg
    libseccomp
    libxml2
    python3
    wayland
    wayland-protocols
    libxau
    zstd
  ]
  ++ lib.optional withDconf dconf
  ++ lib.optional withGlibNetworking glib-networking
  ++ lib.optional withPolkit polkit
  ++ lib.optional withSystemd systemd;

  propagatedBuildInputs = [
    glib
    ostree
  ];

  mesonFlags = [
    (lib.mesonBool "auto_sideloading" withAutoSideloading)
    (lib.mesonBool "installed_tests" false)
    (lib.mesonBool "tests" false)
    (lib.mesonEnable "dconf" withDconf)
    (lib.mesonEnable "docbook_docs" withDocbookDocs)
    (lib.mesonEnable "gir" withIntrospection)
    (lib.mesonEnable "gtkdoc" withGtkDoc)
    (lib.mesonEnable "malcontent" false)
    (lib.mesonEnable "man" withMan)
    (lib.mesonEnable "selinux_module" withSELinuxModule)
    (lib.mesonEnable "system_helper" withPolkit)
    (lib.mesonEnable "systemd" withSystemd)
    (lib.mesonOption "dbus_config_dir" (placeholder "out" + "/share/dbus-1/system.d"))
    (lib.mesonOption "profile_dir" (placeholder "out" + "/etc/profile.d"))
    (lib.mesonOption "system_bubblewrap" (lib.getExe bubblewrap))
    (lib.mesonOption "system_dbus_proxy" (lib.getExe xdg-dbus-proxy))
    (lib.mesonOption "system_fusermount" "/run/wrappers/bin/fusermount3")
    (lib.mesonOption "system_install_dir" "/var/lib/flatpak")
    (lib.mesonOption "sysconfdir" "/etc")
  ];

  doCheck = false;

  separateDebugInfo = true;

  meta = {
    description = "Linux application sandboxing and distribution framework";
    homepage = "https://flatpak.org/";
    changelog = "https://github.com/flatpak/flatpak/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    mainProgram = "flatpak";
    platforms = lib.platforms.linux;
  };
})

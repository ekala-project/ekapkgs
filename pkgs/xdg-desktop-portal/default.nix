{
  lib,
  fetchFromGitHub,
  fetchFromGitLab,
  flatpak ? null,
  fuse3,
  bubblewrap,
  docutils,
  systemdMinimal,
  geoclue2,
  glib,
  gsettings-desktop-schemas,
  json-glib,
  meson,
  ninja,
  pipewire,
  gdk-pixbuf,
  librsvg,
  python3,
  pkg-config,
  stdenv,
  wrapGAppsNoGuiHook,
  bash,
  gst_all_1,
  libgudev,
  replaceVars,
  enableGeoLocation ? true,
  enableSystemd ? true,
}:

let
  libglnxSrc = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libglnx";
    rev = "ff64d52116ae74f0d25e24f089db28921ea171ff";
    hash = "sha256-U6+vIU/wxnGGg07FJElQijbV0+jUswdG/lfzhw4wQy0=";
  };
  gvdbSrc = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gvdb";
    rev = "c6f2359cc1d00f16e0a0e2527fa0bc1882b8b5ab";
    hash = "sha256-FQPctq+fj6du0sBawaJxtO0PRO0KIHHhdA2jh24Yacw=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal";
  version = "1.22.1";

  outputs = [
    "out"
    "installedTests"
  ];
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "xdg-desktop-portal";
    tag = finalAttrs.version;
    hash = "sha256-GYPc5gFw3vMiDbrw5h6xeU7wupfyWeWq/Vl+vVrX8h0=";
  };

  patches = [
    (replaceVars ./fix-icon-validation.patch {
      inherit (builtins) storeDir;
    })

    (replaceVars ./fix-sound-validation.patch {
      inherit (builtins) storeDir;
    })

    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    docutils
    glib
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    fuse3
    bubblewrap
    glib
    gsettings-desktop-schemas
    json-glib
    pipewire
    gst_all_1.gst-plugins-base
    libgudev

    # For icon validator
    gdk-pixbuf
    librsvg
    bash
  ]
  ++ lib.optionals (flatpak != null) [ flatpak ]
  ++ lib.optionals enableGeoLocation [
    geoclue2
  ]
  ++ lib.optionals enableSystemd [
    systemdMinimal
  ];

  mesonFlags = [
    "--sysconfdir=/etc"
    "-Dinstalled-tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
    "-Ddocumentation=disabled"
    (lib.mesonEnable "systemd" enableSystemd)
  ]
  ++ lib.optionals (!enableGeoLocation) [
    "-Dgeoclue=disabled"
  ]
  ++ lib.optionals (!finalAttrs.finalPackage.doCheck) [
    "-Dtests=disabled"
  ];

  strictDeps = true;

  doCheck = false;

  postPatch = ''
    mkdir -p subprojects/{libglnx,gvdb}
    cp -r ${libglnxSrc}/* subprojects/libglnx/
    cp -r ${gvdbSrc}/* subprojects/gvdb/

    substituteInPlace meson.build \
      --replace-fail "find_program('bwrap'"  "find_program('${lib.getExe bubblewrap}'"

    patchShebangs src/generate-method-info.py
  '';

  preFixup = lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    mkdir $installedTests
  '';

  meta = {
    description = "Desktop integration portals for sandboxed apps";
    homepage = "https://flatpak.github.io/xdg-desktop-portal";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

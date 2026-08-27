{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  buildPackages,
  colord,
  cups,
  gcr_4,
  geoclue2,
  geocode-glib_2,
  gettext,
  glib,
  gnome-desktop,
  gsettings-desktop-schemas,
  libcanberra,
  libnotify,
  meson,
  ninja,
  pkg-config,
  polkit,
  systemd,
  tzdata,
  upower,
  # TODO: gnome-session-ctl - need to port or find equivalent
  # TODO: libgweather - being ported
  # TODO: networkmanager - not available
  # TODO: alsa-lib - not yet available in ekapkgs
  # TODO: bashNonInteractive - not yet available in ekapkgs
  # TODO: fontconfig - not yet available in ekapkgs
  # TODO: libgudev - not yet available in ekapkgs
  # TODO: libpulseaudio - not yet available in ekapkgs
  # TODO: libx11 - not yet available in ekapkgs
  # TODO: libxfixes - not yet available in ekapkgs
  # TODO: modemmanager - not yet available in ekapkgs
  # TODO: perl - not yet available in ekapkgs
  # TODO: udevCheckHook - not yet available in ekapkgs
  # TODO: wrapGAppsNoGuiHook - not yet available in ekapkgs
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-settings-daemon";
  version = "50.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${lib.versions.major finalAttrs.version}/gnome-settings-daemon-${finalAttrs.version}.tar.xz";
    hash = "sha256-3SyXMJFPDs7KAindiowpQKV93rCAJDRVjUsWTXnP4Fw=";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/merge_requests/202
    ./add-gnome-session-ctl-option.patch

    (replaceVars ./fix-paths.patch {
      inherit tzdata;
    })
  ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
    pkg-config
  ];

  nativeBuildInputs = [
    gettext
    glib
    meson
    ninja
    # TODO: perl
    pkg-config
    # TODO: udevCheckHook
    # TODO: wrapGAppsNoGuiHook
  ];

  buildInputs = [
    # TODO: alsa-lib
    # TODO: bashNonInteractive
    colord
    cups
    # TODO: fontconfig
    gcr_4
    geoclue2
    geocode-glib_2
    glib
    gnome-desktop
    gsettings-desktop-schemas
    libcanberra
    # TODO: libgudev
    # TODO: libgweather - being ported
    libnotify
    # TODO: libpulseaudio
    # TODO: libx11
    # TODO: libxfixes
    # TODO: modemmanager
    # TODO: networkmanager - not available
    polkit
    upower
  ]
  ++ lib.optionals withSystemd [
    systemd
  ];

  mesonFlags = [
    "-Dudev_dir=${placeholder "out"}/lib/udev"
    (lib.mesonBool "systemd" withSystemd)
  ];
  # TODO: uncomment once gnome-session-ctl is available
  # ++ lib.optionals withSystemd [
  #   "-Dgnome_session_ctl_path=${gnome-session-ctl}/libexec/gnome-session-ctl"
  # ];

  # Default for release buildtype but passed manually because
  # we're using plain
  env.NIX_CFLAGS_COMPILE = "-DG_DISABLE_CAST_CHECKS";

  postPatch = ''
    for f in plugins/power/gsd-power-constants-update.pl; do
      chmod +x $f
      patchShebangs $f
    done
  '';

  meta = {
    description = "GNOME Settings Daemon";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-settings-daemon/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

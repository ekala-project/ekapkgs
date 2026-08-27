{
  fetchurl,
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  glib,
  gsettings-desktop-schemas,
  gnome-desktop,
  dbus,
  gettext,
  systemd,
  # TODO: gnome-session-ctl - need to port or find equivalent
  # TODO: gnome-settings-daemon - being ported
  # TODO: gnome-shell - being ported
  # TODO: xmlto - not yet available in ekapkgs
  # TODO: docbook_xsl - not yet available in ekapkgs
  # TODO: docbook_xml_dtd_45 - not yet available in ekapkgs
  # TODO: libxslt - not yet available in ekapkgs
  # TODO: wrapGAppsNoGuiHook - not yet available in ekapkgs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-session";
  version = "50.1";

  outputs = [
    "out"
    "sessions"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-session/${lib.versions.major finalAttrs.version}/gnome-session-${finalAttrs.version}.tar.xz";
    hash = "sha256-Yom2r6RNPkyZnOV2H/iywQujCfVflCXysT+YIIyB9vs=";
  };

  patches = [
    # https://github.com/NixOS/nixpkgs/pull/48517
    ./nixos_set_environment_done.patch
  ];

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    gettext
    # TODO: xmlto
    # TODO: libxslt
    # TODO: docbook_xsl
    # TODO: docbook_xml_dtd_45
    dbus # for DTD
    # TODO: wrapGAppsNoGuiHook
  ];

  buildInputs = [
    glib
    gnome-desktop
    # TODO: gnome-settings-daemon - being ported
    gsettings-desktop-schemas
    systemd
  ];

  # TODO: postPatch requires gnome-session-ctl to be available
  # postPatch = ''
  #   # Use our provided `gnome-session-ctl`
  #   original="@libexecdir@/gnome-session-ctl"
  #   replacement="${gnome-session-ctl}/libexec/gnome-session-ctl"
  #
  #   find data/ -type f -name "*.service.in" -exec sed -i \
  #     -e s,$original,$replacement,g \
  #     {} +
  # '';

  # We move the GNOME sessions to another output since gnome-session is a dependency of
  # GDM itself. If we do not hide them, it will show broken GNOME sessions when GDM is
  # enabled without proper GNOME installation.
  postInstall = ''
    mkdir $sessions
    moveToOutput share/wayland-sessions "$sessions"

    # Our provided one is being used
    rm -rf $out/libexec/gnome-session-ctl
  '';

  # TODO: preFixup requires gnome-shell and gnome-settings-daemon (being ported)
  # preFixup = ''
  #   gappsWrapperArgs+=(
  #     --suffix XDG_DATA_DIRS : "${gnome-shell}/share"
  #     --suffix XDG_CONFIG_DIRS : "${gnome-settings-daemon}/etc/xdg"
  #   )
  # '';

  separateDebugInfo = true;

  passthru = {
    providedSessions = [
      "gnome"
    ];
  };

  meta = {
    description = "GNOME session manager";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-session";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-session/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

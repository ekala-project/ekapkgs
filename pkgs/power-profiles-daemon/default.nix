{
  stdenv,
  lib,
  bash-completion ? null,
  pkg-config,
  meson,
  ninja,
  fetchFromGitLab,
  libgudev,
  glib,
  polkit,
  dbus,
  gobject-introspection,
  gettext,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_412 ? null,
  libxml2,
  libxslt,
  upower,
  systemd,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "power-profiles-daemon";
  version = "0.30";

  outputs = [
    "out"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "upower";
    repo = "power-profiles-daemon";
    rev = finalAttrs.version;
    hash = "sha256-iQUhA46BEln8pyIBxM/MY7An8BzfiFjxZdR/tUIj4S4=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    gettext
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
    libxml2
    libxslt
    gobject-introspection
    python3
  ];

  buildInputs = [
    bash-completion
    libgudev
    systemd
    upower
    glib
    polkit
    python3
  ];

  strictDeps = true;

  mesonFlags = [
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dgtk_doc=true"
    "-Dpylint=disabled"
    "-Dmanpage=disabled"
    "-Dbashcomp=disabled"
    "-Dzshcomp="
    "-Dtests=false"
  ];

  doCheck = false;

  env.PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";

  postPatch = ''
    # Remove the Python 'gi' module checks since pygobject3 is not available
    substituteInPlace meson.build \
      --replace-fail "python3_required_modules += 'gi'" \
                     "# python3_required_modules += 'gi'" \
      --replace-fail "gi_required_modules += powerprofilesctl_required_gi_modules" \
                     "# gi_required_modules += powerprofilesctl_required_gi_modules"

    patchShebangs --host \
      src/powerprofilesctl
  '';

  meta = {
    changelog = "https://gitlab.freedesktop.org/upower/power-profiles-daemon/-/releases/${finalAttrs.version}";
    homepage = "https://gitlab.freedesktop.org/upower/power-profiles-daemon";
    description = "Makes user-selected power profiles handling available over D-Bus";
    mainProgram = "powerprofilesctl";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
})

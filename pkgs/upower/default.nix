{
  lib,
  stdenv,
  fetchFromGitLab,
  makeWrapper,
  pkg-config,
  libxslt,
  meson,
  ninja,
  python3,
  dbus,
  docbook-xsl-nons,
  udev,
  libgudev,
  libusb1,
  glib,
  gettext,
  polkit,
  gobject-introspection,
  systemd,
  useIMobileDevice ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "upower";
  version = "1.90.6";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "upower";
    repo = "upower";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y3MIB6a11P00B/6E3UyoyjLLP8TIT3vM2FDO7zlBz/w=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    python3
    docbook-xsl-nons
    gettext
    libxslt
    makeWrapper
    pkg-config
    glib
    gobject-introspection
  ];

  buildInputs = [
    libgudev
    libusb1
    udev
    systemd
  ];

  propagatedBuildInputs = [
    glib
    polkit
  ];

  postPatch = ''
    patchShebangs src/linux/integration-test.py
    patchShebangs src/linux/unittest_inspector.py
  '';

  mesonFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "-Dos_backend=linux"
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dudevrulesdir=${placeholder "out"}/lib/udev/rules.d"
    "-Dudevhwdbdir=${placeholder "out"}/lib/udev/hwdb.d"
    "-Dintrospection=enabled"
    "-Dgtk-doc=false"
    "-Didevice=disabled"
  ];

  doCheck = false;

  env = {
    DESTDIR = "dest";
  };

  postInstall = ''
    for o in $(getAllOutputNames); do
        if [[ "$o" = "devdoc" ]]; then continue; fi
        mv "$DESTDIR''${!o}" "$(dirname "''${!o}")"
    done

    mv "$DESTDIR/var" "$out"
    cp --recursive "$DESTDIR/etc" "$out"
    rm --recursive "$DESTDIR/etc"

    rmdir --parents --ignore-fail-on-non-empty "$DESTDIR${builtins.storeDir}"
    ! test -e "$DESTDIR"
  '';

  meta = {
    homepage = "https://upower.freedesktop.org/";
    description = "D-Bus service for power management";
    mainProgram = "upower";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
})

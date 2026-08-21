{
  lib,
  stdenv,
  fetchurl,
  writeText,
  pkg-config,
  meson,
  ninja,
  gettext,
  gnupg,
  p11-kit,
  glib,
  libgcrypt,
  libtasn1,
  pango,
  libsecret,
  openssh,
  systemd,
  gobject-introspection,
  wrapGAppsHook3,
  vala,
  gi-docgen,
  python3,
  shared-mime-info,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:
let
  crossFile = writeText "cross-file.conf" ''
    [binaries]
    ssh-add = '${lib.getExe' openssh "ssh-add"}'
    ssh-agent = '${lib.getExe' openssh "ssh-agent"}'
    ${lib.optionalString systemdSupport "systemctl = '${lib.getExe' systemd "systemctl"}'"}
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gcr";
  version = "4.4.0.1";

  outputs = [
    "out"
    "bin"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gcr/${lib.versions.majorMinor finalAttrs.version}/gcr-${finalAttrs.version}.tar.xz";
    hash = "sha256-DDw0Hkn59PJTKkiEUJgEGQoMJmPmEgNguymMXRdKgJg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    gettext
    gobject-introspection
    gi-docgen
    wrapGAppsHook3
    vala
    shared-mime-info
  ];

  buildInputs = [
    libgcrypt
    libtasn1
    pango
    libsecret
    openssh
  ]
  ++ lib.optionals systemdSupport [
    systemd
  ];

  propagatedBuildInputs = [
    glib
    p11-kit
  ];

  nativeCheckInputs = [
    python3
  ];

  mesonFlags = [
    "-Dgpg_path=${lib.getBin gnupg}/bin/gpg"
    (lib.mesonEnable "systemd" systemdSupport)
    "--cross-file=${crossFile}"
    (lib.mesonBool "gtk4" false)
  ];

  doCheck = false; # fails 21 out of 603 tests, needs dbus daemon

  env.PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";

  postPatch = ''
    patchShebangs gcr/fixtures/
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = {
    platforms = lib.platforms.unix;
    maintainers = [ ];
    description = "GNOME crypto services (daemon and tools)";
    homepage = "https://gitlab.gnome.org/GNOME/gcr";
    license = lib.licenses.lgpl2Plus;
    longDescription = ''
      GCR is a library for displaying certificates, and crypto UI, accessing
      key stores. It also provides the viewer for crypto files on the GNOME
      desktop.

      GCK is a library for accessing PKCS#11 modules like smart cards, in a
      (G)object oriented way.
    '';
  };
})

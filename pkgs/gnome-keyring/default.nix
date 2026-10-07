{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  dbus,
  libgcrypt,
  pam,
  python3,
  glib,
  libxslt,
  gettext,
  gcr,
  libcap_ng,
  libselinux,
  p11-kit,
  gtk3,
  docbook-xsl-nons,
  docbook-xml-dtd,
  useWrappedDaemon ? true,
}:

stdenv.mkDerivation rec {
  pname = "gnome-keyring";
  version = "48.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-keyring/${lib.versions.major version}/gnome-keyring-${version}.tar.xz";
    hash = "sha256-8gUYySDp6j+cm4tEvoxQ2Nf+7NDdViSWD3e9LKT7650=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    gettext
    glib
    libxslt
    docbook-xsl-nons
    docbook-xml-dtd.v4_3
    gtk3.wrapGAppsNoGuiHook
  ];

  buildInputs = [
    glib
    libgcrypt
    pam
    libcap_ng
    libselinux
    gcr
    p11-kit
  ];

  nativeCheckInputs = [
    dbus
    python3
  ];

  mesonEntries = {
    pkcs11-config = "${placeholder "out"}/etc/pkcs11";
    pkcs11-modules = "${placeholder "out"}/lib/pkcs11";
  };

  mesonFeatures = {
    systemd = false;
  };

  doCheck = false;
  strictDeps = true;

  postFixup = lib.optionalString useWrappedDaemon ''
    files=($out/etc/xdg/autostart/* $out/share/dbus-1/services/*)

    for file in ''${files[*]}; do
      substituteInPlace $file \
        --replace "$out/bin/gnome-keyring-daemon" "/run/wrappers/bin/gnome-keyring-daemon"
    done
  '';

  meta = {
    description = "Collection of components in GNOME that store secrets, passwords, keys, certificates and make them available to applications";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-keyring";
    license = [
      lib.licenses.lgpl21Plus
      lib.licenses.gpl2Plus
    ];
    platforms = lib.platforms.linux;
  };
}

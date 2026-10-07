{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  gettext,
  gnupg,
  p11-kit,
  glib,
  libgcrypt,
  libtasn1,
  gtk3,
  pango,
  libsecret,
  openssh,
  python3,
  shared-mime-info,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gcr";
  version = "3.41.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gcr/${lib.versions.majorMinor finalAttrs.version}/gcr-${finalAttrs.version}.tar.xz";
    sha256 = "utEPPFU6DhhUZJq1nFskNNoiyhpUrmE48fU5YVZ+Grc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    python3
    ninja
    gettext
    gtk3.wrapGAppsHook
    shared-mime-info
    openssh
  ];

  buildInputs = [
    libgcrypt
    libtasn1
    pango
    libsecret
    openssh
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    p11-kit
  ];

  mesonEntries = {
    ssh_agent = false;
    gpg_path = "${lib.getBin gnupg}/bin/gpg";
    gtk_doc = false;
    introspection = false;
  };

  mesonFeatures = {
    systemd = false;
  };

  doCheck = false;

  postPatch = ''
    patchShebangs gcr/fixtures/ || true

    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
    substituteInPlace meson_post_install.py --replace ".so" "${stdenv.hostPlatform.extensions.sharedLibrary}"
  '';

  meta = {
    description = "GNOME crypto services (daemon and tools)";
    homepage = "https://gitlab.gnome.org/GNOME/gcr";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})

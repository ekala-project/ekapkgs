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
  wrapGAppsHook3,
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
    wrapGAppsHook3
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

  mesonFlags = [
    (lib.mesonBool "ssh_agent" false)
    "-Dgpg_path=${lib.getBin gnupg}/bin/gpg"
    (lib.mesonBool "gtk_doc" false)
    (lib.mesonBool "introspection" false)
    (lib.mesonEnable "systemd" false)
  ];

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

{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  pkg-config,
  glib,
  shadow,
  gobject-introspection,
  polkit,
  systemd,
  coreutils,
  meson,
  dbus,
  ninja,
  python3,
  vala,
  gettext,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  pname = "accountsservice";
  version = "23.13.9";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/accountsservice/accountsservice-${version}.tar.xz";
    sha256 = "rdpM3q4k+gmS598///nv+nCQvjrCM6Pt/fadWpybkk8=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit shadow coreutils;
    })
    ./no-create-dirs.patch
    ./Disable-methods-that-change-files-in-etc.patch
    ./drop-prefix-check-extensions.patch
    ./get-dm-type-from-config.patch
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    dbus
    gettext
    glib
    polkit
    systemd
    libxcrypt
  ];

  env =
    lib.optionalAttrs (stdenv.cc.isGNU && (lib.versionAtLeast (lib.getVersion stdenv.cc.cc) "14"))
      {
        NIX_CFLAGS_COMPILE = toString [
          "-Wno-error=deprecated-declarations"
          "-Wno-error=implicit-function-declaration"
          "-Wno-error=return-mismatch"
        ];
      };

  mesonFlags = [
    "-Dadmin_group=wheel"
    "-Dlocalstatedir=/var"
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  meta = {
    description = "D-Bus interface for user account query and manipulation";
    homepage = "https://www.freedesktop.org/wiki/Software/AccountsService";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}

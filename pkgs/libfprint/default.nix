{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  meson,
  python3,
  ninja,
  gusb,
  pixman,
  glib,
  cairo,
  libgudev,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "libfprint";
  version = "1.94.9";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libfprint";
    repo = "libfprint";
    rev = "v${version}";
    hash = "sha256-UiUdZokgi27LlyO419dd+NIcQD2RSUfdsC08sW3qzko=";
  };

  postPatch = ''
    patchShebangs \
      tests/unittest_inspector.py \
      tests/virtual-image.py \
      tests/umockdev-test.py \
      tests/test-generated-hwdb.sh
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    python3
  ];

  buildInputs = [
    gusb
    pixman
    glib
    cairo
    libgudev
    openssl
  ];

  mesonFlags = [
    "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d"
    "-Ddrivers=all"
    "-Dudev_hwdb_dir=${placeholder "out"}/lib/udev/hwdb.d"
    "-Dintrospection=false"
    "-Ddoc=false"
  ];

  doCheck = false;

  meta = {
    homepage = "https://fprint.freedesktop.org/";
    description = "Library designed to make it easy to add support for consumer fingerprint readers";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.linux;
  };
}

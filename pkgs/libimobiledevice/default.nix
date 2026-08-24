{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  openssl,
  libgcrypt,
  libplist,
  libtasn1,
  libusbmuxd,
  libimobiledevice-glue,
}:

stdenv.mkDerivation rec {
  pname = "libimobiledevice";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libimobiledevice";
    rev = "9ccc52222c287b35e41625cc282fb882544676c6";
    hash = "sha256-pNvtDGUlifp10V59Kah4q87TvLrcptrCJURHo+Y+hs4=";
  };

  patches = [
    (fetchpatch {
      name = "fime.h.patch";
      url = "https://github.com/libimobiledevice/libimobiledevice/commit/92256c2ae2422dac45d8648a63517598bdd89883.patch";
      hash = "sha256-sB+wEFuXFoQnuf7ntWfvYuCgWfYbmlPL7EjW0L0F74o=";
    })
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

  configureFlags = [ "--without-cython" ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    openssl
    libgcrypt
    libplist
    libtasn1
    libusbmuxd
    libimobiledevice-glue
  ];

  outputs = [
    "out"
    "dev"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/libimobiledevice/libimobiledevice";
    description = "Software library that talks the protocols to support iPhone, iPod Touch and iPad devices on Linux";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}

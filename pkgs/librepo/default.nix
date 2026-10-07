{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  pkg-config,
  libxml2,
  glib,
  openssl,
  zchunk,
  curl,
  check,
  gpgme,
  libselinux,
  doxygen,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.21.2";
  pname = "librepo";

  outputs = [
    "out"
    "dev"
    "py"
  ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "librepo";
    tag = finalAttrs.version;
    hash = "sha256-txNE6GjXjflUpB5Sija068MxQ+q1ESqdNtaMLEQsgJ0=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    doxygen
  ];

  buildInputs = [
    python3
    libxml2
    glib
    openssl
    curl
    check
    gpgme
    zchunk
    libselinux
  ];

  # librepo/fastestmirror.h includes curl/curl.h, and pkg-config specfile refers to others in here
  propagatedBuildInputs = [
    curl
    gpgme
    libxml2
  ];

  cmakeEntries = {
    PYTHON_DESIRED = "${lib.substring 0 1 python3.pythonVersion}";
    PYTHON_EXECUTABLE = "${python3.interpreter}";
  };

  postFixup = ''
    moveToOutput "lib/${python3.libPrefix}" "$py"
  '';

  meta = {
    description = "Library providing C and Python (libcURL like) API for downloading linux repository metadata and packages";
    homepage = "https://rpm-software-management.github.io/librepo/";
    changelog = "https://github.com/rpm-software-management/dnf5/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  zlib,
  pcre2,
  utf8proc,
  expat,
  sqlite,
  openssl,
  unixodbc,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "poco";
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "pocoproject";
    repo = "poco";
    hash = "sha256-mUONqjbKHvdsTM6zk9/QLEr1lVV6f9I/shLW2B8iqMk=";
    tag = "poco-${version}-release";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    unixodbc
    libpng
  ];

  propagatedBuildInputs = [
    zlib
    pcre2
    utf8proc
    expat
    sqlite
    openssl
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    "-DPOCO_UNBUNDLED=ON"
    "-DENABLE_TESTS=OFF"
    "-DENABLE_DATA_MYSQL=OFF"
  ];

  postFixup = ''
    grep -rlF INTERFACE_INCLUDE_DIRECTORIES "$dev/lib/cmake/Poco" | while read -r f; do
      substituteInPlace "$f" \
        --replace-quiet "$"'{_IMPORT_PREFIX}/include' ""
    done
  '';

  meta = {
    homepage = "https://pocoproject.org/";
    description = "Cross-platform C++ libraries with a network/internet focus";
    license = lib.licenses.boost;
    platforms = lib.platforms.unix;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libpq,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpqxx";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = "libpqxx";
    rev = finalAttrs.version;
    hash = "sha256-f5mGtag+AfGCXDio/tE2TWhWx5VfVUrSUjX/Jwc5xsc=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    libpq
  ];

  cmakeFlags = [
    "-DBUILD_DOC=OFF"
    "-DBUILD_TEST=OFF"
  ];

  doCheck = false;

  strictDeps = true;

  meta = {
    changelog = "https://github.com/jtv/libpqxx/releases/tag/${finalAttrs.version}";
    description = "C++ library to access PostgreSQL databases";
    homepage = "https://pqxx.org/development/libpqxx/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})

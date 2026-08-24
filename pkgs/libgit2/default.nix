{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  zlib,
  libssh2,
  openssl,
  pcre2,
  llhttp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgit2";
  version = "1.9.7";

  outputs = [
    "lib"
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kBQqTxMIWMCZJA1SuxVb29Y7k+V1Y2qVR2EntoY4FUo=";
  };

  cmakeFlags = [
    "-DREGEX_BACKEND=pcre2"
    "-DUSE_HTTP_PARSER=llhttp"
    "-DUSE_SSH=ON"
    "-DUSE_GSSAPI=OFF"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    python3
    pkg-config
  ];

  buildInputs = [
    zlib
    libssh2
    openssl
    pcre2
    llhttp
  ];

  doCheck = false;

  meta = {
    description = "Linkable library implementation of Git that you can use in your application";
    mainProgram = "git2";
    homepage = "https://libgit2.org/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})

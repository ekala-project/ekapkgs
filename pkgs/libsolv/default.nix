{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  zlib,
  xz,
  bzip2,
  zchunk,
  zstd,
  expat,
  withRpm ? false,
  rpm ? null,
  db,
  withConda ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.7.39";
  pname = "libsolv";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "libsolv";
    rev = finalAttrs.version;
    hash = "sha256-nl1g1BKauSXV54xjO/1jDQMbr1WfycupR0CPqkgkzrA=";
  };

  cmakeEntries = {
    ENABLE_COMPLEX_DEPS = "true";
    ENABLE_CONDA = withConda;
    ENABLE_LZMA_COMPRESSION = "true";
    ENABLE_BZIP2_COMPRESSION = "true";
    ENABLE_ZSTD_COMPRESSION = "true";
    ENABLE_ZCHUNK_COMPRESSION = "true";
    WITH_SYSTEM_ZCHUNK = "true";
  };

  cmakeFlags = lib.optionals withRpm [
    "-DENABLE_COMPS=true"
    "-DENABLE_PUBKEY=true"
    "-DENABLE_RPMDB=true"
    "-DENABLE_RPMDB_BYRPMHEADER=true"
    "-DENABLE_RPMMD=true"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
  ];
  buildInputs = [
    zlib
    xz
    bzip2
    zchunk
    zstd
    expat
    db
  ]
  ++ lib.optional withRpm rpm;

  meta = {
    description = "Free package dependency solver";
    homepage = "https://github.com/openSUSE/libsolv";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})

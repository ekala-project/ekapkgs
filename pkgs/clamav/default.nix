{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  cmake,
  zlib,
  bzip2,
  libiconv,
  libxml2,
  openssl,
  ncurses,
  curl,
  libmilter,
  pcre2,
  libmspack,
  enableSystemd ? false,
  systemd ? null,
  json_c,
  check,
  rustc,
  rust-bindgen,
  rustfmt,
  cargo,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clamav";
  version = "1.5.2";

  src = fetchurl {
    url = "https://www.clamav.net/downloads/production/clamav-${finalAttrs.version}.tar.gz";
    hash = "sha256-80AYzyLwW92dGhV0ygcZPj4DDKUgUMPlwiDiOjIxSWU=";
  };

  patches = [
    ./sample-configuration-file-install-location.patch
    ./use-non-existent-file-with-proper-permissions.patch
  ];

  enableParallelBuilding = true;
  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    rustc
    rust-bindgen
    rustfmt
    cargo
    python3
  ];
  buildInputs = [
    zlib
    bzip2
    libxml2
    openssl
    ncurses
    curl
    libiconv
    libmilter
    pcre2
    libmspack
    json_c
    check
  ]
  ++ lib.optional (enableSystemd && systemd != null) systemd;

  cmakeFlags = [
    "-DAPP_CONFIG_DIRECTORY=/etc/clamav"
    "-DCVD_CERTS_DIRECTORY=${placeholder "out"}/share/clamav/certs"
  ]
  ++ lib.optionals (enableSystemd && systemd != null) [
    "-DSYSTEMD_UNIT_DIR=${placeholder "out"}/lib/systemd"
  ]
  ++ lib.optionals (!enableSystemd || systemd == null) [
    "-DENABLE_SYSTEMD=OFF"
  ];

  doCheck = false;

  meta = {
    homepage = "https://www.clamav.net";
    description = "Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

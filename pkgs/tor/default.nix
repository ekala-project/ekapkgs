{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libevent,
  openssl,
  zlib,
  libseccomp,
  systemd,
  libcap,
  xz,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "tor";
  version = "0.4.8.16";

  src = fetchurl {
    url = "https://dist.torproject.org/${pname}-${version}.tar.gz";
    sha256 = "sha256-ZUDdN3oSD7jn0nUwqjt/9yoPpbT2cP4dZMmHwc/TkMs=";
  };

  outputs = [
    "out"
    "geoip"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libevent
    openssl
    zlib
    xz
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libseccomp
    systemd
    libcap
  ];

  patches = [ ./disable-monotonic-timer-tests.patch ];

  postPatch = ''
    patchShebangs ./scripts/maint/checkShellScripts.sh
  '';

  configureFlags =
    # cross compiles correctly but needs the following
    lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [ "--disable-tool-name-check" ]
    ++
      # sandbox is broken on aarch64-linux https://gitlab.torproject.org/tpo/core/tor/-/issues/40599
      lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
        "--disable-seccomp"
      ];

  NIX_CFLAGS_LINK = lib.optionalString stdenv.cc.isGNU "-lgcc_s";

  enableParallelBuilding = true;

  # disable tests on linux aarch32
  # https://gitlab.torproject.org/tpo/core/tor/-/issues/40912
  doCheck = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch32);

  postInstall = ''
    mkdir -p $geoip/share/tor
    mv $out/share/tor/geoip{,6} $geoip/share/tor
    rm -rf $out/share/tor
  '';

  meta = with lib; {
    homepage = "https://www.torproject.org/";
    description = "Anonymizing overlay network";
    license = with licenses; [
      bsd3
      gpl3Only
    ];
    platforms = platforms.unix;
  };
}

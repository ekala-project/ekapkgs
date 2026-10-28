{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnutls,
  liburcu,
  lmdb,
  libcap_ng,
  libidn2 ? null,
  libunistring,
  systemdLibs,
  nettle,
  libedit,
  zlib,
  libiconv,
  libintl,
  libmaxminddb,
  libbpf,
  nghttp2,
  libmnl,
  ngtcp2-gnutls,
  xdp-tools ? null,
  fstrm,
  protobufc,
  autoreconfHook,
  tzdata,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "knot-dns";
  version = "3.6.1";

  src = fetchurl {
    url = "https://knot-dns.nic.cz/release/knot-${finalAttrs.version}.tar.xz";
    sha256 = "9af5818f6b53f8a387e013676a308d5c932bdb469d47f1ca926e1842badea75e";
  };

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  configureFlags = [
    "--with-configdir=/etc/knot"
    "--with-rundir=/run/knot"
    "--with-storage=/var/lib/knot"
    "--with-module-dnstap"
    "--enable-dnstap"
    "--without-xdp"
  ];

  patches = [
    # Don't try to create directories like /var/lib/knot at build time.
    # They are later created from NixOS itself.
    ./dont-create-run-time-dirs.patch
    ./runtime-deps.patch
  ];

  nativeBuildInputs = [
    pkg-config
    protobufc # dnstap support
    autoreconfHook
    tzdata # tests/contrib/test_time
  ];

  buildInputs = [
    gnutls
    liburcu
    libidn2
    libunistring
    nettle
    libedit
    libiconv
    lmdb
    libintl
    nghttp2 # DoH support in kdig
    ngtcp2-gnutls # DoQ support in kdig (and elsewhere but not much use there yet)
    libmaxminddb # optional for geoip module (it's tiny)
    # without sphinx &al. for developer documentation
    fstrm
    protobufc # dnstap support
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap_ng
    systemdLibs
    xdp-tools
    libbpf
    libmnl # XDP support (it's Linux kernel API)
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin zlib; # perhaps due to gnutls

  strictDeps = true;

  env.CFLAGS = toString [
    "-O2"
    "-DNDEBUG"
  ];

  __darwinAllowLocalNetworking = true;

  doCheck = true;
  checkFlags = [ "V=1" ]; # verbose output in case some test fails
  doInstallCheck = true;

  postInstall = ''
    rm -r "$out"/lib/*.la
  '';

  passthru = {
    # TODO(ekaos): replace with integrationTests
    # tests = {
    #   inherit knot-resolver_5;
    # }
    # // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    #   inherit knot-resolver-manager_6;
    #   inherit (nixosTests) knot kea;
    #   prometheus-exporter = nixosTests.prometheus-exporters.knot;
    # };
  };

  meta = {
    description = "Authoritative-only DNS server from .cz domain registry";
    homepage = "https://knot-dns.cz";
    changelog = "https://gitlab.nic.cz/knot/knot-dns/-/releases/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "knotd";
  };
})

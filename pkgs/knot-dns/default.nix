{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnutls,
  liburcu,
  lmdb,
  libcap_ng ? null,
  libidn2,
  libunistring,
  systemd ? null,
  nettle,
  libedit,
  zlib,
  libiconv ? null,
  libintl ? null,
  libmaxminddb ? null,
  libbpf ? null,
  nghttp2,
  libmnl ? null,
  ngtcp2-gnutls ? null,
  xdp-tools ? null,
  fstrm ? null,
  protobufc ? null,
  sphinx ? null,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "knot-dns";
  version = "3.5.6";

  src = fetchurl {
    url = "https://knot-dns.nic.cz/release/knot-${finalAttrs.version}.tar.xz";
    sha256 = "8e2dde44c97f8a63ec5e6c11db26099acd5341286af5b6be900b62ccade68898";
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
  ]
  ++ lib.optionals (fstrm != null && protobufc != null) [
    "--with-module-dnstap"
    "--enable-dnstap"
  ];

  patches = [
    ./dont-create-run-time-dirs.patch
    ./runtime-deps.patch
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ]
  ++ lib.optionals (protobufc != null) [ protobufc ]
  ++ lib.optionals (sphinx != null) [ sphinx ];

  buildInputs = [
    gnutls
    liburcu
    libidn2
    libunistring
    nettle
    libedit
    lmdb
    nghttp2
  ]
  ++ lib.optionals (libiconv != null) [ libiconv ]
  ++ lib.optionals (libintl != null) [ libintl ]
  ++ lib.optionals (ngtcp2-gnutls != null) [ ngtcp2-gnutls ]
  ++ lib.optionals (libmaxminddb != null) [ libmaxminddb ]
  ++ lib.optionals (fstrm != null) [ fstrm ]
  ++ lib.optionals (protobufc != null) [ protobufc ]
  ++ lib.optionals stdenv.hostPlatform.isLinux (
    lib.filter (x: x != null) [
      libcap_ng
      systemd
      xdp-tools
      libbpf
      libmnl
    ]
  );

  enableParallelBuilding = true;
  strictDeps = true;

  env.CFLAGS = toString [
    "-O2"
    "-DNDEBUG"
  ];

  doCheck = true;
  checkFlags = [ "V=1" ];

  postInstall = ''
    rm -r "$out"/lib/*.la
  '';

  meta = {
    description = "Authoritative-only DNS server from .cz domain registry";
    homepage = "https://knot-dns.cz";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "knotd";
  };
})

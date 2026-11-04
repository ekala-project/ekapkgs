{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
  bison,
  flex,
  geoip,
  libcli,
  libnet,
  libnetfilter_conntrack,
  libnl,
  libpcap,
  libsodium,
  liburcu,
  ncurses,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsniff-ng";
  version = "0.6.9";

  src = fetchFromGitHub {
    repo = "netsniff-ng";
    owner = "netsniff-ng";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P1xZqhZ/HJV3fAvh4xhhApZ0+FLDFqvYrZlbvb+FV7I=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/netsniff-ng/netsniff-ng/commit/1af7ae33e3e8178ab5c649c3a52838d4375c4228.patch";
      sha256 = "sha256-aNV1Srnr396HsyAKVQoCeGBo/oduxLrUidlZLuI5Rlk=";
    })
  ];

  nativeBuildInputs = [
    bison
    flex
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    geoip
    libcli
    libnet
    libnl
    libnetfilter_conntrack
    libpcap
    libsodium
    liburcu
    ncurses
    zlib
  ];

  configurePhase = ''
    runHook preConfigure

    patchShebangs configure
    substituteInPlace configure --replace "which" "command -v"
    NACL_INC_DIR=${libsodium.dev}/include/sodium NACL_LIB=sodium ./configure

    runHook postConfigure
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "ETCDIR=$(out)/etc"
  ];

  postInstall = ''
    wrapProgram "$out/sbin/trafgen" --prefix PATH ":" "${stdenv.cc}/bin"
    wrapProgram "$out/sbin/bpfc" --prefix PATH ":" "${stdenv.cc}/bin"
  '';

  meta = {
    description = "Swiss army knife for daily Linux network plumbing";
    homepage = "http://netsniff-ng.org/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})

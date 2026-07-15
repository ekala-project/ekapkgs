{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  openssl,
  lua5_4,
  pcre2,
  libssh2,
  libpcap,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "nmap";
  version = "7.97";

  src = fetchurl {
    url = "https://nmap.org/dist/nmap-${version}.tar.bz2";
    hash = "sha256-r5jyeSXGcMJX3Zap3fJyTgbLebL9Hg0IySBjFr4WRcA=";
  };

  configureFlags = [
    "--with-liblua=${lua5_4}"
    "--without-ndiff"
    "--without-zenmap"
  ];

  postInstall = ''
    install -m 444 -D nselib/data/passwords.lst $out/share/wordlists/nmap.lst
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    pcre2
    libssh2
    libpcap
    openssl
    zlib
  ];

  enableParallelBuilding = true;

  doCheck = false;

  meta = {
    description = "Free and open source utility for network discovery and security auditing";
    homepage = "http://www.nmap.org";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    mainProgram = "nmap";
    maintainers = [ ];
  };
}

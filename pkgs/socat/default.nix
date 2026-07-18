{
  lib,
  fetchurl,
  openssl,
  readline,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "socat";
  version = "1.8.0.3";

  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${pname}-${version}.tar.bz2";
    hash = "sha256-AesBc2HZW7OmlB6EC1nkRjo/q/kt9BVO0CsWou1qAJU=";
  };

  postPatch = ''
    patchShebangs test.sh
    substituteInPlace test.sh \
      --replace /bin/rm rm \
      --replace /sbin/ifconfig ifconfig
  '';

  configureFlags =
    lib.optionals (!stdenv.hostPlatform.isLinux) [
      "--disable-posixmq"
    ]
    ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
      "--disable-dccp"
    ];

  buildInputs = [
    openssl
    readline
  ];

  enableParallelBuilding = true;

  doCheck = false; # fails a bunch, hangs

  meta = {
    description = "Utility for bidirectional data transfer between two independent data channels";
    homepage = "http://www.dest-unreach.org/socat/";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Only;
    mainProgram = "socat";
    maintainers = [ ];
  };
}

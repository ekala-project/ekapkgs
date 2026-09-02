{
  lib,
  stdenv,
  fetchurl,
  openssl,
  lksctp-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iperf";
  version = "3.21";

  src = fetchurl {
    url = "https://downloads.es.net/pub/iperf/iperf-${finalAttrs.version}.tar.gz";
    hash = "sha256-ZW5EBevWIBId587KPq9DqI956huFfQQaagsTFIAazdg=";
  };

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isLinux [ lksctp-tools ];

  configureFlags = [ "--with-openssl=${openssl.dev}" ];

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  postInstall = ''
    ln -s $out/bin/iperf3 $out/bin/iperf
    ln -s $man/share/man/man1/iperf3.1 $man/share/man/man1/iperf.1
  '';

  meta = {
    homepage = "https://software.es.net/iperf/";
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    mainProgram = "iperf3";
  };
})

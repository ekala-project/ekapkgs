{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "chkrootkit";
  version = "0.58b";

  src = fetchurl {
    url = "ftp://ftp.chkrootkit.org/pub/seg/pac/chkrootkit-${version}.tar.gz";
    hash = "sha256-de0qzoHw+j6cP7ZNqw6IV+1ZJH6nVfWJhBb+ssZoB7k=";
  };

  postPatch = ''
    # Remove strings-static target (requires static libc)
    substituteInPlace Makefile \
      --replace-fail 'strings-static' ""
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "sense"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/sbin
    install -m755 chkrootkit $out/sbin/
    install -m755 chkwtmp $out/sbin/
    install -m755 chklastlog $out/sbin/
    install -m755 chkproc $out/sbin/
    install -m755 ifpromisc $out/sbin/
    install -m755 strings-static $out/sbin/ 2>/dev/null || true

    runHook postInstall
  '';

  meta = {
    description = "Locally checks for signs of a rootkit";
    homepage = "https://www.chkrootkit.org/";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}

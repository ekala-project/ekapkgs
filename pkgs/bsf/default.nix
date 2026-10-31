{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "bsf";
  version = "2.4.0";

  src = fetchurl {
    url = "https://archive.apache.org/dist/commons/bsf/binaries/bsf-bin-${version}.tar.gz";
    hash = "sha256-KLvWnGIYkiqUrgwvy/WnvyqN5dq8hJFnaHkz5MmGw9c=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/java
    install -m 444 lib/bsf.jar $out/lib/java/

    runHook postInstall
  '';

  meta = {
    description = "Apache Bean Scripting Framework";
    homepage = "https://commons.apache.org/proper/commons-bsf/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}

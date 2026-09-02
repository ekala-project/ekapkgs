{
  buildGo126Module,
  fetchurl,
  lib,
  zstd,
  python3 ? null,
  perl ? null,
}:

buildGo126Module (finalAttrs: {
  pname = "goredo";
  version = "2.6.0";

  src = fetchurl {
    url = "http://www.goredo.cypherpunks.ru/download/goredo-${finalAttrs.version}.tar.zst";
    hash = "sha256-XTL/otfCKC55TsUBBVors2kgFpOFh+6oekOOafOhcUs=";
  };

  nativeBuildInputs = [ zstd ];

  vendorHash = null;

  modRoot = "./src";
  subPackages = [ "." ];

  postBuild = ''
    ( cd $GOPATH/bin; ./goredo -symlinks )
    cd ..
  '';

  doCheck = false;

  postInstall = ''
    mkdir -p "$out/share/info"
    cp goredo.info "$out/share/info"
  '';

  outputs = [
    "out"
    "info"
  ];

  meta = {
    outputsToInstall = [ "out" ];
    description = "Makefile replacement that sucks less";
    homepage = "https://www.goredo.cypherpunks.ru";
    license = lib.licenses.gpl3;
  };
})

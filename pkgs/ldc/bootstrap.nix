{
  lib,
  stdenv,
  fetchurl,
  curl,
  tzdata,
  autoPatchelfHook,
  libxml2,
}:

let
  inherit (stdenv) hostPlatform;
  OS = hostPlatform.parsed.kernel.name;
  ARCH = hostPlatform.parsed.cpu.name;
  version = "1.41.0";
  hashes = {
    linux-x86_64 = "sha256-SkOUV/D+WeadAv1rV1Sfw8h60PVa2fueQlB7b44yfI8=";
    linux-aarch64 = "sha256-HEuVChPVM3ntT1ZDZsJ+xW1iYeIWhogNcMdIaz6Me6g=";
  };
in
stdenv.mkDerivation {
  pname = "ldc-bootstrap";
  inherit version;

  src = fetchurl rec {
    name = "ldc2-${version}-${OS}-${ARCH}.tar.xz";
    url = "https://github.com/ldc-developers/ldc/releases/download/v${version}/${name}";
    hash = hashes."${OS}-${ARCH}" or (throw "missing bootstrap hash for ${OS}-${ARCH}");
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libxml2
    stdenv.cc.cc
  ];

  propagatedBuildInputs = [
    curl
    tzdata
  ];

  installPhase = ''
    mkdir -p $out

    mv bin etc import lib LICENSE README $out/
  '';

  meta = {
    description = "LLVM-based D Compiler";
    homepage = "https://github.com/ldc-developers/ldc";
    license = with lib.licenses; [
      bsd3
      boost
      mit
      ncsa
      gpl2Plus
    ];
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "http-parser";
  version = "2.9.4";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "http-parser";
    rev = "v${finalAttrs.version}";
    sha256 = "1vda4dp75pjf5fcph73sy0ifm3xrssrmf927qd1x8g3q46z0cv6c";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  patches = [
    ./enable-static-shared.patch
  ];

  makeFlags = [
    "DESTDIR="
    "PREFIX=$(out)"
    "BINEXT=${stdenv.hostPlatform.extensions.executable}"
    "Platform=${lib.toLower stdenv.hostPlatform.uname.system}"
    "AEXT=${lib.strings.removePrefix "." stdenv.hostPlatform.extensions.staticLibrary}"
    "ENABLE_SHARED=1"
    "ENABLE_STATIC=0"
    "SOEXT=${lib.strings.removePrefix "." stdenv.hostPlatform.extensions.sharedLibrary}"
  ];

  buildFlags = [ "library" ];

  enableParallelBuilding = true;

  meta = {
    description = "HTTP message parser written in C";
    homepage = "https://github.com/nodejs/http-parser";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})

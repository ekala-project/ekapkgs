{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "llhttp";
  version = "9.4.2";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "llhttp";
    tag = "release/v${finalAttrs.version}";
    hash = "sha256-LS8HS8CnXJ3X8WlIvtxBLc0h1wLL/HmTqZWHlvBjTEo=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    validatePkgConfig
  ];

  cmakeFlags = [
    (lib.cmakeBool "LLHTTP_BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "LLHTTP_BUILD_STATIC_LIBS" stdenv.hostPlatform.isStatic)
  ];

  passthru.meta = {
    description = "Port of http_parser to llparse";
    homepage = "https://llhttp.org/";
    changelog = "https://github.com/nodejs/llhttp/releases/tag/release/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "libllhttp" ];
  };
})

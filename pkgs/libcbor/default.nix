{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cmocka,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcbor";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "PJK";
    repo = "libcbor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zjajNtj4jKbt3pLjfLrgtYljyMDYJtnzAC5JPdt+Wys=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    cmocka
  ];

  cmakeBuildDir = "build.dir";

  cmakeFlags =
    lib.optional finalAttrs.finalPackage.doCheck "-DWITH_TESTS=ON"
    ++ lib.optional (!stdenv.hostPlatform.isStatic) "-DBUILD_SHARED_LIBS=ON";

  doCheck = !stdenv.hostPlatform.isStatic && stdenv.hostPlatform == stdenv.buildPlatform;

  nativeCheckInputs = [ cmocka ];

  meta = {
    changelog = "https://github.com/PJK/libcbor/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "CBOR protocol implementation for C and others";
    homepage = "https://github.com/PJK/libcbor";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})

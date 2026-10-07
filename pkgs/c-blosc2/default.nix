{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,

  static ? stdenv.hostPlatform.isStatic,

  lz4,
  zlib-ng,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "c-blosc2";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc2";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-X/LR88pHbCk0TPu0oGPsg9phXmwnHlXCxdxd+Wa69UY=";
  };

  postPatch = ''
    sed -i -E \
      -e '/^libdir[=]/clibdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      -e '/^includedir[=]/cincludedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@' \
      blosc2.pc.in
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  propagatedBuildInputs = [
    lz4
    zlib-ng
    zstd
  ];

  cmakeEntries = {
    BUILD_STATIC = "${if static then ";
    BUILD_SHARED = "${if static then ";
    PREFER_EXTERNAL_LZ4 = true;
    PREFER_EXTERNAL_ZLIB = true;
    PREFER_EXTERNAL_ZSTD = true;
    BLOSC_ENABLE_ZFP = false;
    BUILD_EXAMPLES = false;
    BUILD_BENCHMARKS = false;
    BUILD_TESTS = "${if finalAttrs.finalPackage.doCheck then ";
  };

  cmakeFlags = [
    ON" else "OFF"}"
    OFF" else "ON"}"
    ON" else "OFF"}"
  ];

  doCheck = !static;
  enableParallelChecking = false;

  meta = {
    description = "Fast, compressed, persistent binary data store library for C";
    homepage = "https://www.blosc.org";
    changelog = "https://github.com/Blosc/c-blosc2/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})

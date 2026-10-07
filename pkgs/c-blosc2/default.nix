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
    BUILD_STATIC = static;
    BUILD_SHARED = !static;
    PREFER_EXTERNAL_LZ4 = true;
    PREFER_EXTERNAL_ZLIB = true;
    PREFER_EXTERNAL_ZSTD = true;
    BLOSC_ENABLE_ZFP = false;
    BUILD_EXAMPLES = false;
    BUILD_BENCHMARKS = false;
    BUILD_TESTS = finalAttrs.finalPackage.doCheck;
  };

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

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

  cmakeFlags = [
    "-DBUILD_STATIC=${if static then "ON" else "OFF"}"
    "-DBUILD_SHARED=${if static then "OFF" else "ON"}"

    "-DPREFER_EXTERNAL_LZ4=ON"
    "-DPREFER_EXTERNAL_ZLIB=ON"
    "-DPREFER_EXTERNAL_ZSTD=ON"

    # ZFP uses FetchContent to download during build, which doesn't work in the sandbox
    "-DBLOSC_ENABLE_ZFP=OFF"

    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_BENCHMARKS=OFF"
    "-DBUILD_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
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

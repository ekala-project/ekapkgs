{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snappy";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "snappy";
    rev = finalAttrs.version;
    hash = "sha256-bMZD8EI9dvDGupfos4hi/0ShBkrJlI5Np9FxE6FfrNE=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    BUILD_SHARED_LIBS = !stdenv.hostPlatform.isStatic;
    SNAPPY_BUILD_TESTS = false;
    SNAPPY_BUILD_BENCHMARKS = false;
  };

  postInstall = ''
    substituteInPlace "$out"/lib/cmake/Snappy/SnappyTargets.cmake \
      --replace 'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/include"' 'INTERFACE_INCLUDE_DIRECTORIES "'$dev'"'

    mkdir -p $dev/lib/pkgconfig
    cat <<EOF > $dev/lib/pkgconfig/snappy.pc
      Name: snappy
      Description: Fast compressor/decompressor library.
      Version: ${finalAttrs.version}
      Libs: -L$out/lib -lsnappy
      Cflags: -I$dev/include
    EOF
  '';

  doCheck = false;

  meta = {
    homepage = "https://google.github.io/snappy/";
    license = lib.licenses.bsd3;
    description = "Compression/decompression library for very high speeds";
    platforms = lib.platforms.all;
  };
})

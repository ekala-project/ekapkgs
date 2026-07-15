{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchpatch,
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

  patches = [
    ./revert-PUBLIC.patch
    (fetchpatch {
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/snappy/reenable-rtti.patch?rev=e3449869b466869fc6b8a03a1a528fa6";
      hash = "sha256-JhVhkHh7XPx1Bzf5xnOgWLgwh1oihX3O+emQWzE4Dho=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
    "-DSNAPPY_BUILD_TESTS=OFF"
    "-DSNAPPY_BUILD_BENCHMARKS=OFF"
  ];

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
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})

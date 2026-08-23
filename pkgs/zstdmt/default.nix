{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gnugrep,
  legacySupport ? false,
  static ? stdenv.hostPlatform.isStatic,
  enableStatic ? static,
  buildContrib ? stdenv.hostPlatform == stdenv.buildPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zstdmt";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "zstd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tNFWIT9ydfozB8dWcmTMuZLCQmQudTFJIkSr0aG7S44=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  postPatch = lib.optionalString (!static) ''
    substituteInPlace build/cmake/CMakeLists.txt \
      --replace 'message(SEND_ERROR "You need to build static library to build tests")' ""
    substituteInPlace build/cmake/tests/CMakeLists.txt \
      --replace 'libzstd_static' 'libzstd_shared'
  '';

  cmakeFlags =
    lib.attrsets.mapAttrsToList (name: value: "-DZSTD_${name}:BOOL=${if value then "ON" else "OFF"}")
      {
        BUILD_SHARED = !static;
        BUILD_STATIC = enableStatic;
        BUILD_CONTRIB = buildContrib;
        PROGRAMS_LINK_SHARED = !static;
        LEGACY_SUPPORT = legacySupport;
        BUILD_TESTS = false;
      };

  cmakeDir = "../build/cmake";
  dontUseCmakeBuildDir = true;
  preConfigure = ''
    mkdir -p build_ && cd $_
  '';

  preInstall = ''
    mkdir -p $bin/bin
    substituteInPlace ../programs/zstdgrep \
      --replace ":-grep" ":-${gnugrep}/bin/grep" \
      --replace ":-zstdcat" ":-$bin/bin/zstdcat"

    substituteInPlace ../programs/zstdless \
      --replace "zstdcat" "$bin/bin/zstdcat"
  ''
  + lib.optionalString buildContrib ''
    cp contrib/pzstd/pzstd $bin/bin/pzstd
  '';

  outputs = [
    "bin"
    "dev"
    "man"
    "out"
  ];

  meta = {
    description = "Zstandard real-time compression algorithm";
    homepage = "https://facebook.github.io/zstd/";
    changelog = "https://github.com/facebook/zstd/blob/v${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.bsd3;
    mainProgram = "zstd";
    platforms = lib.platforms.all;
    maintainers = [ ];
    pkgConfigModules = [ "libzstd" ];
  };
})

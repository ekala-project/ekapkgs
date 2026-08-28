{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ragel,
  python3,
  util-linux,
  pkg-config,
  boost,
  pcre,
  withStatic ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyperscan";
  version = "5.4.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "intel";
    repo = "hyperscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tzmVc6kJPzkFQLUM1MttQRLpgs0uckbV6rCxEZwk1yk=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    sed -i '/examples/d' CMakeLists.txt
    substituteInPlace libhs.pc.in \
      --replace-fail "libdir=@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@" "libdir=@CMAKE_INSTALL_LIBDIR@" \
      --replace-fail "includedir=@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_INCLUDEDIR@" "includedir=@CMAKE_INSTALL_INCLUDEDIR@"

    substituteInPlace cmake/pcre.cmake --replace-fail 'CHECK_C_SOURCE_COMPILES("#include <pcre.h.generic>
        #if PCRE_MAJOR != ''${PCRE_REQUIRED_MAJOR_VERSION} || PCRE_MINOR < ''${PCRE_REQUIRED_MINOR_VERSION}
        #error Incorrect pcre version
        #endif
        main() {}" CORRECT_PCRE_VERSION)' 'set(CORRECT_PCRE_VERSION TRUE)'
  ''
  + ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        "cmake_minimum_required (VERSION 2.8.11)" \
        "cmake_minimum_required (VERSION 3.10)"
  '';

  buildInputs = [ boost ];
  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ragel
    python3
    util-linux
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_AVX512" true)
    (lib.cmakeBool "FAT_RUNTIME" true)
  ]
  ++ lib.optionals withStatic [
    (lib.cmakeBool "BUILD_STATIC_AND_SHARED" true)
  ]
  ++ lib.optionals (!withStatic) [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  preConfigure = lib.optionalString withStatic (
    ''
      mkdir -p pcre
      tar xvf ${pcre.src} --strip-components 1 -C pcre
    ''
    + ''
      substituteInPlace pcre/CMakeLists.txt \
        --replace-fail \
          "CMAKE_MINIMUM_REQUIRED(VERSION 2.8.5)" \
          "CMAKE_MINIMUM_REQUIRED(VERSION 3.10)" \
        --replace-fail \
          "CMAKE_POLICY(SET CMP0026 OLD)" \
          "CMAKE_POLICY(SET CMP0026 NEW)" \
        --replace-fail \
          "GET_TARGET_PROPERTY(PCRETEST_EXE pcretest DEBUG_LOCATION)" \
          "set(PCRETEST_EXE $<TARGET_FILE:pcretest>)"
    ''
  );

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    bin/unit-hyperscan
    ${lib.optionalString withStatic "bin/unit-chimera"}

    runHook postCheck
  '';

  meta = {
    broken = stdenv.hostPlatform.isStatic;
    description = "High-performance multiple regex matching library";
    homepage = "https://www.hyperscan.io/";
    platforms = [
      "x86_64-linux"
    ];
    license = lib.licenses.bsd3;
  };
})

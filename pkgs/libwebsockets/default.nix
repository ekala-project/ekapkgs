{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  zlib,
  libuv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwebsockets";
  version = "4.4.5";

  src = fetchFromGitHub {
    owner = "warmcat";
    repo = "libwebsockets";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VY5caFHEJY06Vb4abDKmfcL12lRkmk0auxb/4ZZwqqc=";
  };

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [
    openssl
    zlib
    libuv
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    LWS_WITH_PLUGINS = true;
    LWS_WITH_IPV6 = true;
    LWS_WITH_SOCKS5 = true;
    DISABLE_WERROR = true;
    LWS_BUILD_HASH = "no_hash";
    LWS_WITHOUT_TESTAPPS = true;
  };

  cmakeFlags = (
    if stdenv.hostPlatform.isStatic then
      [ "-DLWS_WITH_SHARED=OFF" ]
    else
      [
        "-DLWS_WITH_STATIC=OFF"
        "-DLWS_LINK_TESTAPPS_DYNAMIC=ON"
      ]
  );

  postPatch = ''
    substituteInPlace lib/CMakeLists.txt \
      --replace-fail '=\''${exec_prefix}/''${LWS_INSTALL_LIB_DIR}' '=''${CMAKE_INSTALL_FULL_LIBDIR}' \
      --replace-fail '=\''${prefix}/''${LWS_INSTALL_INCLUDE_DIR}' '=''${CMAKE_INSTALL_FULL_INCLUDEDIR}'

    substituteInPlace cmake/lws_config.h.in \
      --replace-fail '"''${CMAKE_INSTALL_PREFIX}/''${LWS_INSTALL_LIB_DIR}"' '"''${CMAKE_INSTALL_FULL_LIBDIR}"'
  '';

  meta = {
    description = "Light, portable C library for websockets";
    homepage = "https://libwebsockets.org/";
    license = with lib.licenses; [
      mit
      publicDomain
      bsd3
      asl20
    ];
    platforms = lib.platforms.all;
  };
})

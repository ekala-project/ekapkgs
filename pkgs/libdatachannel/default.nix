{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  libnice,
  openssl,
  plog,
  srtp,
  usrsctp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdatachannel";
  version = "0.24.6";

  src = fetchFromGitHub {
    owner = "paullouisageneau";
    repo = "libdatachannel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oHebu5e76ors0Bfvaf96Fa+C/y6MU553DhAxakqiDXU=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    libnice
    openssl
    srtp
    usrsctp
    plog
  ];

  cmakeEntries = {
    USE_NICE = true;
    PREFER_SYSTEM_LIB = true;
    NO_EXAMPLES = true;
  };

  postFixup = ''
    # Fix include path that will be incorrect due to the "dev" output
    substituteInPlace "$dev/lib/cmake/LibDataChannel/LibDataChannelTargets.cmake" \
      --replace-fail "\''${_IMPORT_PREFIX}/include" "$dev/include"
  '';

  meta = {
    description = "C/C++ WebRTC network library featuring Data Channels, Media Transport, and WebSockets";
    homepage = "https://libdatachannel.org/";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

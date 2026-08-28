{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  jsoncpp,
  libtins,
  libpcap,
  openssl,
}:

stdenv.mkDerivation {
  pname = "dublin-traceroute";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "insomniacslk";
    repo = "dublin-traceroute";
    rev = "a92118d93fd1fa7bdb827e741dd848b7f7083a1e";
    hash = "sha256-UJeFPVi3423Jh72fVk8QbLX1tTNAQ504xYs9HwVCkZc=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "ENABLE_TESTING()" "" \
      --replace-fail "-std=c++11" "-std=c++17"
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    jsoncpp
    libtins
    libpcap
    openssl
  ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  passthru = {
    # 0.4.2 was tagged in 2017
  };

  meta = {
    description = "NAT-aware multipath traceroute tool";
    homepage = "https://dublin-traceroute.net/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    mainProgram = "dublin-traceroute";
    broken = stdenv.hostPlatform.isDarwin;
  };
}

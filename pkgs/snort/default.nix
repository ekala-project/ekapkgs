{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libdaq,
  libdnet,
  flex,
  hwloc,
  luajit,
  openssl,
  libpcap,
  pcre2,
  pkg-config,
  zlib,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snort";
  version = "3.10.0.0";

  src = fetchFromGitHub {
    owner = "snort3";
    repo = "snort3";
    tag = finalAttrs.version;
    hash = "sha256-vxiZeJByZGS7rXtvPMgNjb94E/oju+mmEuzJ7tA+hE4=";
  };

  nativeBuildInputs = [
    libdaq
    pkg-config
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    libdaq
    libpcap
    stdenv.cc.cc # libstdc++
    libdnet
    flex
    hwloc
    luajit
    openssl
    libpcap
    pcre2
    zlib
    xz
  ];

  patches = [ ./0001-cmake-fix-pkg-config-path-for-libdir.patch ];

  enableParallelBuilding = true;

  meta = {
    description = "Network intrusion prevention and detection system (IDS/IPS)";
    homepage = "https://www.snort.org";
    maintainers = [ ];
    changelog = "https://github.com/snort3/snort3/blob/${finalAttrs.src.rev}/ChangeLog.md";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})

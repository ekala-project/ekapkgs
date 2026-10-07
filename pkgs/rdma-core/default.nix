{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  docutils,
  libnl,
  udev,
  python3,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rdma-core";
  version = "65.0";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "rdma-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cAaWVE6/JU8ezjx+XrxNI6Su6VKxb2Jxl29sxU/yepI=";
  };

  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    docutils
    pkg-config
    python3
  ];

  buildInputs = [
    libnl
    perl
    udev
  ];

  cmakeEntries = {
    CMAKE_INSTALL_RUNDIR = "/run";
    CMAKE_INSTALL_SHAREDSTATEDIR = "/var/lib";
    SYSUSERS_DIR = "${placeholder "out"}/lib/sysusers.d";
    NO_MAN_PAGES = true;
  };

  postPatch = ''
    substituteInPlace srp_daemon/srp_daemon.sh.in \
      --replace /bin/rm rm
  '';

  postInstall = ''
    mkdir -p $out/${perl.libPrefix}
    mv $out/share/perl5/* $out/${perl.libPrefix}
  '';

  postFixup = ''
    for pls in $out/bin/{ibfindnodesusing.pl,ibidsverify.pl}; do
      echo "wrapping $pls"
      substituteInPlace $pls --replace \
        "${perl}/bin/perl" "${perl}/bin/perl -I $out/${perl.libPrefix}"
    done
  '';

  meta = {
    description = "RDMA Core Userspace Libraries and Daemons";
    homepage = "https://github.com/linux-rdma/rdma-core";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})

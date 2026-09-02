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
  version = "64.0";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "rdma-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y0pCGkvCjZ1F9Ojouesozn2Lxj+x7/0ck6/9tJmdkWw=";
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

  cmakeFlags = [
    "-DCMAKE_INSTALL_RUNDIR=/run"
    "-DCMAKE_INSTALL_SHAREDSTATEDIR=/var/lib"
    "-DSYSUSERS_DIR=${placeholder "out"}/lib/sysusers.d"
    "-DNO_MAN_PAGES=1"
  ];

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

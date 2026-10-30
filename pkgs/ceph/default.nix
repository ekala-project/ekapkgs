{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  applyPatches,

  # Build time
  autoconf,
  automake,
  cmake,
  fmt,
  git,
  libtool,
  makeWrapper,
  nasm,
  pkg-config,
  which,
  doxygen,
  graphviz,

  # Python
  python3,

  # Runtime dependencies
  arrow-cpp,
  babeltrace,
  boost,
  bzip2,
  cryptsetup,
  cunit,
  e2fsprogs,
  getopt,
  gperf,
  grep,
  gtest,
  icu,
  kmod,
  libcap,
  libcap_ng,
  libnbd,
  libnl,
  libxml2,
  lmdb,
  lttng-ust,
  lua,
  lvm2,
  lz4,
  oath-toolkit,
  openldap,
  parted,
  rdkafka,
  rocksdb,
  snappy,
  openssh,
  sqlite,
  utf8proc,
  xfsprogs,
  zlib,
  zstd,

  # Optional Dependencies
  curl,
  expat,
  fuse ? null,
  libatomic_ops,
  libedit,
  yasm,

  # Mallocs
  jemalloc,

  # Crypto Dependencies
  nss,
  nspr,

  # Linux Only Dependencies
  linuxHeaders,
  systemd,
  util-linux,
  libuuid,
  udev,
  keyutils,
  rdma-core,
  rabbitmq-c,
  libaio,
  libxfs ? null,
  liburing,

  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

let
  cephSrc = applyPatches {
    pname = "ceph-src";
    version = "20.2.4";

    src = fetchurl {
      url = "https://download.ceph.com/tarballs/ceph-20.2.4.tar.gz";
      hash = "sha256-XzRWkkGiiQRGuTHwbNhE+TvKZl90CiBjFCnS1Vsemzc=";
    };

    patches = [
      (fetchpatch2 {
        name = "ceph-s3select-arrow-cpp-20.patch";
        url = "https://github.com/ceph/s3select/pull/169.diff?full_index=1";
        extraPrefix = "src/s3select/";
        stripLen = 1;
        hash = "sha256-0jn5X4jIdluCufFXWHeO6skMz6XQpliHkC1tPLK6dbk=";
      })
      (fetchpatch2 {
        name = "ceph-20.2.1-backport-gcc16-fixes.patch";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/ceph-20.2.1-backport-gcc16-fixes.patch?h=ceph&id=b158fda8a3e3834a7aa362954dc17077dc46f609";
        hash = "sha256-uLl20Sdd+JJFWqbMHIZRt53OpGRXlTaceajgpzYCaTM=";
        excludes = [
          "src/test/CMakeLists.txt"
          "src/rgw/CMakeLists.txt"
        ];
      })
      (fetchpatch2 {
        name = "ceph-20.2.4-radosgw-gcc16-fixes.patch";
        url = "https://github.com/ceph/ceph/pull/69166.patch?full_index=1";
        hash = "sha256-yaqOrmw0ZItT2efzNfpDqjTRsva8VN0R+TLqbTX0snc=";
      })
    ];
  };

  pythonEnv = python3.withPackages (
    ps: with ps; [
      cython
      pyyaml
      setuptools
      bcrypt
      cherrypy
      jinja2
      natsort
      numpy
      pecan
      prettytable
      pyjwt
      pyopenssl
      python-dateutil
      requests
      routes
      scipy
      sphinx
      virtualenv
      werkzeug
      xmltodict
      markupsafe
      cryptography
      jsonpatch
      cmd2
      colorama
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ceph";
  inherit (cephSrc) version;

  src = cephSrc;

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    cmake.configurePhaseHook
    fmt
    git
    makeWrapper
    libtool
    nasm
    pkg-config
    pythonEnv
    python3.pkgs.setuptools
    python3.pkgs.wrapPython
    which
    doxygen
    graphviz
  ];

  buildInputs = [
    nss
    nspr
    arrow-cpp
    babeltrace
    boost
    bzip2
    pythonEnv
    cryptsetup
    cunit
    e2fsprogs
    gperf
    gtest
    icu
    libcap
    libnbd
    libnl
    libxml2
    lmdb
    lttng-ust
    lua.v5_4
    lvm2
    lz4
    jemalloc
    oath-toolkit
    openldap
    libatomic_ops
    yasm
    parted
    rdkafka
    rocksdb
    snappy
    openssh
    sqlite
    utf8proc
    xfsprogs
    zlib
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    keyutils
    libcap_ng
    liburing
    libuuid
    linuxHeaders
    libaio
    libxfs
    rabbitmq-c
    rdma-core
    udev
    util-linux
  ]
  ++ [
    curl
    expat
    fuse
    libedit
  ];

  inherit (pythonEnv) sitePackages;

  pythonPath = [
    pythonEnv
    "$(out)/${pythonEnv.sitePackages}"
  ];

  preConfigure = ''
    unset AS

    substituteInPlace src/common/module.c \
      --replace-fail "char command[128];" "char command[256];" \
      --replace-fail "/sbin/modinfo"  "${kmod}/bin/modinfo" \
      --replace-fail "/sbin/modprobe" "${kmod}/bin/modprobe" \
      --replace-fail "/bin/grep" "${grep}/bin/grep"

    substituteInPlace src/client/fuse_ll.cc \
      --replace-fail "mount -i -o remount" "${util-linux}/bin/mount -i -o remount"

    substituteInPlace systemd/*.service.in \
      --replace-quiet "/bin/kill" "${util-linux}/bin/kill"

    substituteInPlace src/{ceph-osd-prestart.sh,ceph-post-file.in,init-ceph.in} \
       --replace-fail "GETOPT=/usr/local/bin/getopt" "GETOPT=${getopt}/bin/getopt" \
       --replace-fail "GETOPT=getopt" "GETOPT=${getopt}/bin/getopt"

    export PYTHONPATH=$PYTHONPATH:$lib/$sitePackages:$out/$sitePackages
    patchShebangs src/
  '';

  cmakeEntries = {
    WITH_CEPHFS_SHELL = true;
    WITH_SYSTEMD = withSystemd;
    WITH_JAEGER = false;
    WITH_TESTS = false;
    WITH_SYSTEM_ARROW = true;
    WITH_SYSTEM_BOOST = true;
    WITH_SYSTEM_GTEST = true;
    WITH_SYSTEM_ROCKSDB = true;
    WITH_SYSTEM_UTF8PROC = true;
    WITH_SYSTEM_ZSTD = true;
    CEPHADM_BUNDLED_DEPENDENCIES = "none";
    WITH_UADK = false;
    WITH_MGR_DASHBOARD_FRONTEND = false;
    WITH_XFS = stdenv.hostPlatform.isLinux;
  };

  cmakeFlags = [
    (lib.cmakeOptionType "path" "CMAKE_INSTALL_DATADIR" "$(lib)/lib")
    "-DSYSTEMD_SYSTEM_UNIT_DIR=$(out)/lib/systemd/system"
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux (lib.cmakeBool "WITH_SYSTEM_LIBURING" true);

  preBuild = ''
    cmake --build . --target legacy-option-headers -j 1
  '';

  postFixup = ''
    wrapPythonPrograms
    wrapProgram $out/bin/ceph-mgr \
      --prefix PYTHONPATH : "$(toPythonPath $(out)):$(toPythonPath ${pythonEnv})" \
      --prefix PATH : $out/bin

    test -f $out/bin/ceph-volume

    ! grep -F -r 'GETOPT=getopt' $out
    ! grep -F -r 'GETOPT=/usr/local/bin/getopt' $out
  '';

  outputs = [
    "out"
    "lib"
    "dev"
    "doc"
    "man"
  ];

  # Takes 7+h to build with 2 cores.
  requiredSystemFeatures = [ "big-parallel" ];

  passthru = {
    inherit (cephSrc) version;
    pythonEnv = pythonEnv;
  };

  meta = {
    homepage = "https://ceph.io/en/";
    description = "Distributed storage system";
    license = with lib.licenses; [
      lgpl21
      gpl2Only
      bsd3
      mit
      publicDomain
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})

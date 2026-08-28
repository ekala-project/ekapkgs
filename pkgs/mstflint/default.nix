{
  lib,
  stdenv,
  fetchFromGitHub,
  rdma-core ? null,
  openssl,
  zlib,
  xz,
  expat,
  bashNonInteractive ? null,
  boost,
  curl,
  pkg-config,
  libxml2,
  pciutils ? null,
  busybox ? null,
  python3,
  automake,
  autoconf,
  libtool,
  git,
  onlyFirmwareUpdater ? false,
  enableDPA ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mstflint";
  version = "4.36.0-1";

  src = fetchFromGitHub {
    owner = "Mellanox";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-H4NMSjSOSmkM9lDcbsEBOB6AM5GBRKUoCDWm5QbaS3g=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    libxml2
    git
  ];

  buildInputs = [
    rdma-core
    zlib
    libxml2
    openssl
  ]
  ++ lib.optionals (!onlyFirmwareUpdater) [
    bashNonInteractive
    boost
    curl
    expat
    xz
    python3
  ];

  preConfigure = ''
    export CPPFLAGS="-I$(pwd)/tools_layouts -isystem ${libxml2.dev}/include/libxml2"
    export INSTALL_BASEDIR=$out
    ./autogen.sh
  '';

  prePatch = [
    ''
      patchShebangs eval_git_sha.sh
      substituteInPlace configure.ac \
          --replace "build_cpu" "host_cpu"
      substituteInPlace common/compatibility.h \
          --replace "#define ROOT_PATH \"/\"" "#define ROOT_PATH \"$out/\""
      substituteInPlace configure.ac \
          --replace 'Whether to use GNU C regex])' 'Whether to use GNU C regex])],[AC_MSG_RESULT([yes])'
    ''
    (lib.optionals (!onlyFirmwareUpdater) ''
      substituteInPlace common/python_wrapper.sh \
        --replace \
        'exec $PYTHON_EXEC $SCRIPT_PATH "$@"' \
        'export PATH=$PATH:${
          lib.makeBinPath [
            (placeholder "out")
            pciutils
            busybox
          ]
        }; exec ${python3}/bin/python3 $SCRIPT_PATH "$@"'
    '')
  ];

  configureFlags = [
    "--enable-xml2"
    "--datarootdir=${placeholder "out"}/share"
  ]
  ++ lib.optionals (!onlyFirmwareUpdater) [
    "--enable-adb-generic-tools"
    "--enable-cs"
    "--enable-dc"
    "--enable-fw-mgr"
    "--enable-inband"
    "--enable-rdmem"
  ]
  ++ lib.optionals enableDPA [
    "--enable-dpa"
  ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  dontDisableStatic = true;

  meta = {
    description = "Open source version of Mellanox Firmware Tools (MFT)";
    homepage = "https://github.com/Mellanox/mstflint";
    license = with lib.licenses; [
      gpl2Only
      bsd2
    ];
    platforms = lib.platforms.linux;
  };
})

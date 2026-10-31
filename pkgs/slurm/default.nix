{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libtool,
  curl,
  python3,
  munge,
  perl,
  pam,
  shadow,
  coreutils,
  dbus,
  libbpf,
  ncurses,
  libmysqlclient,
  lua5_2_compat,
  hwloc,
  numactl,
  readline,
  freeipmi,
  xauth,
  lz4,
  rdma-core,
  pmix,
  libjwt,
  libyaml,
  json_c,
  llhttp,
  enableX11 ? true,
  enablePAM ? true,
  symlinkJoin,
  s2n-tls,
}:
let
  lua = lua5_2_compat;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "slurm";
  version = "26-05-4-1";

  src = fetchFromGitHub {
    owner = "SchedMD";
    repo = "slurm";
    tag = "slurm-${builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-R3kHM9CohiJljffYKEe4CdNltKNQkcRuPFqOT0y+3n0=";
  };

  outputs = [
    "out"
    "dev"
  ];

  prePatch = ''
    substituteInPlace src/common/env.c \
        --replace-fail "/bin/echo" "${lib.getExe' coreutils "echo"}"

    substituteInPlace src/plugins/mpi/pmix/mpi_pmix.c \
        --replace-fail 'xstrfmtcat(full_path, "%s/", PMIXP_LIBPATH)' \
                       'xstrfmtcat(full_path, "${lib.getLib pmix}/lib/")'

  ''
  + (lib.optionalString enableX11 ''
    substituteInPlace src/common/x11_util.c \
        --replace-fail '"/usr/bin/xauth"' '"${lib.getExe xauth}"'
  '');

  hardeningDisable = [ "bindnow" ];

  nativeBuildInputs = [
    pkg-config
    libtool
    python3
    perl
  ];
  buildInputs = [
    curl
    python3
    munge
    pam
    libmysqlclient
    ncurses
    lz4
    rdma-core
    lua
    hwloc
    numactl
    readline
    freeipmi
    shadow.su
    pmix
    json_c
    libjwt
    libyaml
    dbus
    libbpf
    llhttp
    s2n-tls
  ]
  ++ lib.optionals enableX11 [ xauth ];

  configureFlags = [
    "--with-freeipmi=${freeipmi}"
    "--with-llhttp-parser=${lib.getDev llhttp}"
    "--with-hwloc=${lib.getDev hwloc}"
    "--with-json=${lib.getDev json_c}"
    "--with-jwt=${libjwt}"
    "--with-lz4=${lib.getDev lz4}"
    "--with-munge=${lib.getDev munge}"
    "--with-yaml=${lib.getDev libyaml}"
    "--with-ofed=${lib.getDev rdma-core}"
    "--sysconfdir=/etc/slurm"
    "--with-pmix=${lib.getDev pmix}"
    "--with-bpf=${libbpf}"
    "--enable-slurmrestd"
    "--with-s2n=${
      symlinkJoin {
        name = s2n-tls.name;
        paths = [
          s2n-tls
          (lib.getDev s2n-tls)
        ];
      }
    }"
    "--without-rpath"
  ]
  ++ (lib.optional (!enableX11) "--disable-x11")
  ++ (lib.optionals enablePAM [
    "--enable-pam"
    "--with-pam_dir=${placeholder "out"}/lib/security"
  ]);

  preConfigure = ''
    patchShebangs ./doc/html/shtml2html.py
    patchShebangs ./doc/man/man2html.py
  ''
  + (lib.optionalString enablePAM ''
    mkdir -p $out/lib/security
  '');
  postConfigure = lib.optionalString enablePAM ''
    rm -rf $out
  '';

  postBuild = lib.optionalString enablePAM ''
    make -C contribs/pam
    make -C contribs/pam_slurm_adopt
  '';

  postInstall =
    (lib.optionalString enablePAM ''
      export LIBRARY_PATH="$PWD/src/api/.libs:''${LIBRARY_PATH:+:$LIBRARY_PATH}"
      mkdir -p $out/lib/security
      make -C contribs/pam install
      make -C contribs/pam_slurm_adopt install
    '')
    + ''
      rm -f $out/lib/*.la $out/lib/slurm/*.la $out/lib/security/*.la
    '';

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.schedmd.com/";
    description = "Simple Linux Utility for Resource Management";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
  };
})

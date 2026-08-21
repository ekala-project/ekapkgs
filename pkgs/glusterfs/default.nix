{
  lib,
  stdenv,
  fetchFromGitHub,
  fuse3,
  bison,
  flex,
  openssl,
  python3,
  ncurses,
  readline,
  autoconf,
  automake,
  libtool,
  pkg-config,
  zlib,
  libaio,
  libxml2,
  acl,
  sqlite,
  liburcu,
  liburing,
  attr,
  makeWrapper,
  coreutils,
  gnused,
  gnugrep,
  which,
  openssh,
  gawk,
  findutils,
  util-linux,
  lvm2,
  btrfs-progs,
  e2fsprogs,
  xfsprogs,
  systemd,
  rsync,
  getent,
  rpcsvc-proto,
  libtirpc,
  gperftools,
}:
let
  buildInputs = [
    fuse3
    openssl
    ncurses
    readline
    zlib
    libaio
    libxml2
    acl
    sqlite
    liburcu
    attr
    util-linux
    libtirpc
    gperftools
    liburing
    (python3.withPackages (pkgs: [
      pkgs.flask
      pkgs.prettytable
      pkgs.requests
    ]))
    python3
  ];
  propagatedBuildInputs = [
    acl
  ];
  runtimePATHdeps = [
    attr
    btrfs-progs
    coreutils
    e2fsprogs
    findutils
    gawk
    getent
    gnugrep
    gnused
    lvm2
    openssh
    rsync
    systemd
    util-linux
    which
    xfsprogs
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "glusterfs";
  version = "11.2";

  src = fetchFromGitHub {
    owner = "gluster";
    repo = "glusterfs";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-MGTntR9SVmejgpAkZnhJOaIkZeCMNBGaQSorLOStdjo=";
  };
  inherit buildInputs propagatedBuildInputs;

  patches = [
    ./ssl_cert_path.patch
  ];

  postPatch = ''
    sed -e '/chmod u+s/d' -i contrib/fuse-util/Makefile.am
    substituteInPlace libglusterfs/src/glusterfs/lvm-defaults.h \
      --replace-fail '/sbin/' '${lvm2}/bin/'
    substituteInPlace libglusterfs/src/glusterfs/compat.h \
      --replace-fail '/bin/umount' '${util-linux}/bin/umount'
    substituteInPlace contrib/fuse-lib/mount-gluster-compat.h \
      --replace-fail '/bin/mount' '${util-linux}/bin/mount'
    substituteInPlace autogen.sh \
      --replace-fail '$ACLOCAL -I ./contrib/aclocal' '$ACLOCAL'
  '';

  preConfigure = ''
    patchShebangs build-aux/pkg-version
    echo "v${finalAttrs.version}" > VERSION
    ./autogen.sh
    export PYTHON=${python3}/bin/python
  '';

  configureFlags = [
    "--localstatedir=/var"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    bison
    flex
    makeWrapper
    rpcsvc-proto
  ];

  makeFlags = [ "DESTDIR=$(out)" ];

  enableParallelBuilding = true;

  postInstall = ''
    cp -r $out/$out/* $out
    rm -r $out/nix
    # this gets falsely loaded as module by glusterfind
    rm -rf $out/bin/conf.py
  '';

  postFixup = ''
    GLUSTER_PATH="${lib.makeBinPath runtimePATHdeps}:$out/bin"
    GLUSTER_PYTHONPATH="$(toPythonPath $out):$out/libexec/glusterfs"
    GLUSTER_LD_LIBRARY_PATH="$out/lib"

    wrapProgram $out/bin/glusterd --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    wrapProgram $out/bin/gluster --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    wrapProgram $out/sbin/mount.glusterfs --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"

    wrapProgram $out/bin/gluster-eventsapi --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    wrapProgram $out/bin/gluster-georep-sshkey --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    wrapProgram $out/bin/gluster-mountbroker --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    wrapProgram $out/bin/glusterfind --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"

    wrapProgram $out/share/glusterfs/scripts/eventsdash.py --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    wrapProgram $out/libexec/glusterfs/glusterfind/brickfind.py --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    wrapProgram $out/libexec/glusterfs/glusterfind/changelog.py --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
  '';

  # installCheck disabled: gfid_to_path.py requires pyxattr which is not available
  doInstallCheck = false;

  env = {
    DETERMINISTIC_BUILD = 1;
    PYTHONHASHSEED = 0;
  };

  meta = {
    description = "Distributed storage system";
    homepage = "https://www.gluster.org";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = with lib.platforms; linux ++ freebsd;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  expat,
  ncurses,
  pciutils,
  numactl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hwloc";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "open-mpi";
    repo = "hwloc";
    tag = "hwloc-${finalAttrs.version}";
    hash = "sha256-lbh8tkKeUcHta7/q9TuHQhccyWjkBgrC5fVifFJqQyY=";
  };

  configureFlags = [
    "--localstatedir=/var"
    "--enable-netloc"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    expat
    ncurses
    numactl
  ];

  propagatedBuildInputs = [ pciutils ];

  enableParallelBuilding = true;

  postInstall = ''
    if [ -d "${numactl}/lib64" ]; then
      numalibdir="${numactl}/lib64"
    else
      numalibdir="${numactl}/lib"
      test -d "$numalibdir"
    fi

    sed -i "$lib/lib/libhwloc.la" \
      -e "s|-lnuma|-L$numalibdir -lnuma|g"
  '';

  doCheck = false;

  outputs = [
    "out"
    "lib"
    "dev"
    "doc"
    "man"
  ];

  meta = {
    description = "Portable abstraction of hierarchical architectures for high-performance computing";
    license = lib.licenses.bsd3;
    homepage = "https://www.open-mpi.org/projects/hwloc/";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

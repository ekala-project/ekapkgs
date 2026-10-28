{
  stdenv,
  lib,
  fetchurl,
  autoconf,
  automake,
  gfortran,
  hwloc,
  openssh,
  perl,
  python3,
  removeReferencesTo,
  # either libfabric or ucx work for ch4backend on linux. On darwin, neither of
  # these libraries currently build so this argument is ignored on Darwin.
  ch4backend ? null,
  # Process managers to build (`--with-pm`),
  # cf. https://github.com/pmodels/mpich/blob/b80a6d7c24defe7cdf6c57c52430f8075a0a41d6/README.vin#L562-L586
  withPm ? [
    "hydra"
    "gforker"
  ],
  pmix,
  # PMIX support is likely incompatible with process managers (`--with-pm`)
  # https://github.com/NixOS/nixpkgs/pull/274804#discussion_r1432601476
  pmixSupport ? false,
}:

let
  withPmStr = if withPm != [ ] then builtins.concatStringsSep ":" withPm else "no";

  # Binaries that should go in the "dev" output.
  # These are all MPI compilers (wrappers around gcc, really).
  develBins = [
    "bin/mpicc"
    "bin/mpic++"
    "bin/mpicxx"
    "bin/mpif77"
    "bin/mpif90"
    "bin/mpifort"
  ];

  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
in

assert (ch4backend == null || ch4backend.pname == "ucx" || ch4backend.pname == "libfabric");

stdenv.mkDerivation (finalAttrs: {
  pname = "mpich";
  version = "5.0.2";

  src = fetchurl {
    url = "https://www.mpich.org/static/downloads/${finalAttrs.version}/mpich-${finalAttrs.version}.tar.gz";
    hash = "sha256-kowvGNNQqRRD/oAkrQHOLGAJ6cVR4Kc+eX/FZ/EZE30=";
  };

  outputs = [
    "out"
    "bin"
    "dev"
    "doc"
    "man"
  ];

  configureFlags = [
    "--enable-shared"
    "--with-pm=${withPmStr}"
    "--sysconfdir=$(dev)/etc"
  ]
  ++ lib.optionals pmixSupport [
    "--with-pmix"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gfortran
    perl
    python3
    removeReferencesTo
  ];

  buildInputs = [
    perl
    openssh
    hwloc
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) ch4backend
  ++ lib.optional pmixSupport pmix;

  postInstall =
    # Move compiler binaries into $dev.
    ''
      for f in ${lib.concatStringsSep " " develBins}; do
        moveToOutput "$f" "''${!outputDev}"
      done
    ''
    # Ensure the default compilers are the ones mpich was built with
    + ''
      sed -i 's:CC="gcc":CC=${stdenv.cc}/bin/gcc:' "$dev"/bin/mpicc
      sed -i 's:CXX="g++":CXX=${stdenv.cc}/bin/g++:' "$dev"/bin/mpicxx
      sed -i 's:FC="gfortran":FC=${gfortran}/bin/gfortran:' "$dev"/bin/mpifort
    '';

  # The entire configure line is embedded into some binaries, so we can end up with cycles between
  # outputs, or one output depending on all other outputs. Since the configure line embedding does
  # not affect functionality, we can simply break its references.
  postFixup = ''
    remove-references-to \
      -t "''${!outputBin}" \
      -t "''${!outputDev}" \
      -t "''${!outputDoc}" \
      -t "''${!outputMan}" \
      $(find "$out"/lib -type f -name 'libmpi${libExt}*')
    remove-references-to \
      -t "''${!outputDev}" \
      -t "''${!outputDoc}" \
      -t "''${!outputMan}" \
      $(find "$bin"/bin -type f)
  '';

  meta = {
    # As far as we know, --with-pmix silently disables all of `--with-pm`
    broken = pmixSupport && withPm != [ ];

    description = "Implementation of the Message Passing Interface (MPI) standard";

    longDescription = ''
      MPICH2 is a free high-performance and portable implementation of
      the Message Passing Interface (MPI) standard, both version 1 and
      version 2.
    '';
    homepage = "http://www.mcs.anl.gov/mpi/mpich2/";
    license = lib.licenses.mpich2;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

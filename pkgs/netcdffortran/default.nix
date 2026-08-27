{
  lib,
  stdenv,
  fetchFromGitHub,
  netcdf,
  hdf5,
  curl,
  gfortran,
  m4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "netcdf-fortran";
  version = "4.6.4";

  src = fetchFromGitHub {
    owner = "Unidata";
    repo = "netcdf-fortran";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-k3cPO293Qc+YGlRI1Lz73zuGPP1A+m+VfOk5hBgeDoM=";
  };

  nativeBuildInputs = [
    gfortran
    m4
  ];
  buildInputs = [
    netcdf
    hdf5
    curl
  ];

  doCheck = true;

  env = {
    FFLAGS = toString [ "-std=legacy" ];
    FCFLAGS = toString [ "-std=legacy" ];
  };

  meta = {
    description = "Fortran API to manipulate netcdf files";
    mainProgram = "nf-config";
    homepage = "https://www.unidata.ucar.edu/software/netcdf/";
    license = lib.licenses.free;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  fftw,
  netcdf,
  pcre2,
  gdal,
  blas,
  lapack,
  ghostscript,
  dcw-gmt,
  gshhg-gmt,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmt";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "GenericMappingTools";
    repo = "gmt";
    tag = finalAttrs.version;
    hash = "sha256-ODJwnjZjWpR5Dg0gNimtrOCCgseJ8INfKEBKP7/bYIc=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  env = {
    NIX_LDFLAGS = "-lxml2 -L${lib.getLib libxml2}/lib";
  };

  buildInputs = [
    curl
    gdal
    netcdf
    pcre2
    dcw-gmt
    gshhg-gmt
    fftw.float
    blas
    lapack
  ];

  propagatedBuildInputs = [ ghostscript ];

  cmakeFlags = [
    (lib.cmakeFeature "GMT_DOCDIR" "share/doc/gmt")
    (lib.cmakeFeature "GMT_MANDIR" "share/man")
    (lib.cmakeFeature "GMT_LIBDIR" "lib")
    (lib.cmakeBool "COPY_GSHHG" false)
    (lib.cmakeFeature "GSHHG_ROOT" "${gshhg-gmt.out}/share/gshhg-gmt")
    (lib.cmakeBool "COPY_DCW" false)
    (lib.cmakeFeature "DCW_ROOT" "${dcw-gmt.out}/share/dcw-gmt")
    (lib.cmakeFeature "GDAL_ROOT" "${gdal.out}")
    (lib.cmakeFeature "NETCDF_ROOT" "${netcdf.out}")
    (lib.cmakeFeature "PCRE2_ROOT" "${pcre2.out}")
    (lib.cmakeBool "GMT_INSTALL_TRADITIONAL_FOLDERNAMES" false)
    (lib.cmakeBool "GMT_ENABLE_OPENMP" true)
    (lib.cmakeBool "GMT_INSTALL_MODULE_LINKS" false)
    (lib.cmakeFeature "LICENSE_RESTRICTED" "LGPL")
    (lib.cmakeFeature "FFTW3_ROOT" "${fftw.float.dev}")
    (lib.cmakeFeature "LAPACK_LIBRARY" "${lib.getLib lapack}/lib/liblapack.so")
    (lib.cmakeFeature "BLAS_LIBRARY" "${lib.getLib blas}/lib/libblas.so")
  ];

  meta = {
    homepage = "https://www.generic-mapping-tools.org";
    description = "Generic Mapping Tools";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})

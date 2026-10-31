{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  blas,
  lapack,
  suitesparse,
  glpk,
  gsl,
  fftw,
}:

buildPythonPackage rec {
  pname = "cvxopt";
  version = "1.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gFnO9B8fEVyHvJt1/sn4bblefwr88DpS1hm6Qz5EO8s=";
  };

  buildInputs = [
    blas
    lapack
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  env = {
    CVXOPT_BLAS_LIB = "blas";
    CVXOPT_LAPACK_LIB = "lapack";
    CVXOPT_BUILD_DSDP = "0";
    CVXOPT_SUITESPARSE_LIB_DIR = "${lib.getLib suitesparse}/lib";
    CVXOPT_SUITESPARSE_INC_DIR = "${lib.getDev suitesparse}/include";
    CVXOPT_BUILD_GSL = "1";
    CVXOPT_GSL_LIB_DIR = "${lib.getLib gsl}/lib";
    CVXOPT_GSL_INC_DIR = "${lib.getDev gsl}/include";
    CVXOPT_BUILD_GLPK = "1";
    CVXOPT_GLPK_LIB_DIR = "${lib.getLib glpk}/lib";
    CVXOPT_GLPK_INC_DIR = "${lib.getDev glpk}/include";
    CVXOPT_BUILD_FFTW = "1";
    CVXOPT_FFTW_LIB_DIR = "${lib.getLib fftw}/lib";
    CVXOPT_FFTW_INC_DIR = "${lib.getDev fftw}/include";
  };

  doCheck = false;

  pythonImportsCheck = [ "cvxopt" ];

  meta = {
    description = "Python Software for Convex Optimization";
    homepage = "https://cvxopt.org/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}

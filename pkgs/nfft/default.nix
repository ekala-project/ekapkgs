{
  autoconf,
  automake,
  cunit,
  fetchFromGitHub,
  fetchpatch,
  fftw,
  lib,
  libtool,
  llvmPackages,
  stdenv,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nfft";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "NFFT";
    repo = "nfft";
    rev = finalAttrs.version;
    hash = "sha256-3x2IHbtPVpaA1AGolDsu1QCygmF3bkSPkCFVBlMtrqE=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    cunit
    libtool
    bash
  ];

  preConfigure = ''
    bash bootstrap.sh
  '';

  configureFlags = [
    "--enable-all"
    "--enable-openmp"
    "--enable-portable-binary"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";


  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  propagatedBuildInputs = [ fftw ];

  doCheck = true;

  meta = {
    description = "Nonequispaced fast Fourier transform";
    homepage = "https://www-user.tu-chemnitz.de/~potts/nfft/";
    license = lib.licenses.gpl2Plus;
  };
})

{
  buildPackages,
  fetchurl,
  lib,
  stdenv,
  libgcrypt,
  readline,
  libgpg-error,
}:

stdenv.mkDerivation rec {
  pname = "freeipmi";
  version = "1.6.15";

  src = fetchurl {
    url = "mirror://gnu/freeipmi/${pname}-${version}.tar.gz";
    sha256 = "sha256-1pKcNUY59c51tbGJfos2brY2JcI+XEWQp66gNP4rjK8=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  buildInputs = [
    libgcrypt
    readline
    libgpg-error
  ];

  configureFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "ac_cv_file__dev_urandom=true"
    "ac_cv_file__dev_random=true"
  ];

  # Fix GCC 14 build.
  # https://savannah.gnu.org/bugs/?65203
  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  doCheck = true;

  meta = {
    description = "Implementation of the Intelligent Platform Management Interface";
    homepage = "https://www.gnu.org/software/freeipmi/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.gnu ++ lib.platforms.linux;
  };
}

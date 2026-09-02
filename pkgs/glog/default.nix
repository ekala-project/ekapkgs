{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gflags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glog";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "glog";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+nwWP6VBmhgU7GCPSEGUzvUSCc48wXME181WpJ5ABP4=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  propagatedBuildInputs = [ gflags ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DWITH_UNWIND=OFF"
    "-DBUILD_TESTING=OFF"
  ];

  meta = {
    homepage = "https://github.com/google/glog";
    license = lib.licenses.bsd3;
    description = "Library for application-level logging";
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zeromq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppzmq";
  version = "4.11.0";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "cppzmq";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-c6IZ5PnuB96NLYHDHdNclYSF4LpqAfFWxVzeP8BzhCE=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  propagatedBuildInputs = [ zeromq ];

  cmakeFlags = [
    "-DCPPZMQ_BUILD_TESTS=OFF"
  ];

  meta = {
    homepage = "https://github.com/zeromq/cppzmq";
    license = lib.licenses.bsd2;
    description = "C++ binding for 0MQ";
    platforms = lib.platforms.unix;
  };
})

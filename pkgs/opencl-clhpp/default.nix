{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  ruby ? null,
  opencl-headers,
  khronos-ocl-icd-loader ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencl-clhpp";
  version = "2026.05.29";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-CLHPP";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    sha256 = "sha256-VrI6cufrIXUizV2exKnQ5B1zjKzWsX5imp3ON39BkSw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    python3
  ];

  propagatedBuildInputs = [ opencl-headers ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "OPENCL_CLHPP_BUILD_TESTING" false)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
  ];

  meta = {
    description = "OpenCL Host API C++ bindings";
    homepage = "http://github.khronos.org/OpenCL-CLHPP/";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

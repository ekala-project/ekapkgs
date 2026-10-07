{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "civetweb";
  version = "1.16";

  src = fetchFromGitHub {
    owner = "civetweb";
    repo = "civetweb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eXb5f2jhtfxDORG+JniSy17kzB7A4vM0UnUQAfKTquU=";
  };

  patches = [
    ./fix-pkg-config-files.patch
    (fetchpatch {
      name = "CVE-2025-55763.patch";
      url = "https://github.com/civetweb/civetweb/commit/76e222bcb77ba8452e5da4e82ae6cecd499c25e0.patch";
      hash = "sha256-gv2FR53SxmRCCTRjj17RhIjoHkgOz5ENs9oHmcfFmw8=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  # The existence of the "build" script causes `mkdir -p build` to fail:
  #   mkdir: cannot create directory 'build': File exists
  preConfigure = ''
    rm build
  '';

  cmakeEntries = {
    BUILD_SHARED_LIBS = true;
    CIVETWEB_ENABLE_CXX = true;
    CIVETWEB_ENABLE_IPV6 = true;
    CIVETWEB_BUILD_TESTING = false;
    CIVETWEB_THREAD_STACK_SIZE = false;
    CMAKE_POLICY_VERSION_MINIMUM = "3.5";
  };

  meta = {
    description = "Embedded C/C++ web server";
    mainProgram = "civetweb";
    homepage = "https://github.com/civetweb/civetweb";
    license = lib.licenses.mit;
  };
})

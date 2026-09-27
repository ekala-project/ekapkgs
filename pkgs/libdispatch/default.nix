{
  lib,
  clangStdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

clangStdenv.mkDerivation {
  pname = "libdispatch";
  version = "5.10.1";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "swift-corelibs-libdispatch";
    rev = "swift-5.10.1-RELEASE";
    name = "swift-corelibs-libdispatch-5.10.1-src";
    hash = "sha256-pta3wJj2LJ/lsYAWQpw0wSGLDMO41mN8Zbl78LUCaQo=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/swiftlang/swift-corelibs-libdispatch/commit/30bb8019ba79cdae0eb1dc0c967c17996dd5cc0a.patch";
      hash = "sha256-wPZQ4wtEWk8HaKMfzjamlU6p/IW5EFiTssY63rGM+ZA=";
    })
    (fetchpatch {
      url = "https://github.com/swiftlang/swift-corelibs-libdispatch/commit/38872e2d44d66d2fb94186988509defc734888a5.patch";
      hash = "sha256-GABwDeTjciV36Sa0FS10mCfFCqRoBBstgW/OiKdPahA=";
    })

    ./disable-swift-overlay.patch
  ];

  meta = {
    description = "Grand Central Dispatch";
    homepage = "https://github.com/swiftlang/swift-corelibs-libdispatch";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
  };
}

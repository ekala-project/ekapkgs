{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  cmake,
  libuuid,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "biblesync";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "karlkleinpaste";
    repo = "biblesync";
    tag = finalAttrs.version;
    sha256 = "0prmd12jq2cjdhsph5v89y38j7hhd51dr3r1hivgkhczr3m5hf4s";
  };

  patches = [
    (fetchpatch {
      name = "cmake-4.patch";
      url = "https://github.com/karlkleinpaste/biblesync/commit/4b00f9fd3d0c858947eee18206ef44f9f6bd2283.patch?full_index=1";
      hash = "sha256-CVYhYBDneLN3Ogvye01EQCc9zxjSwaKBzk1fBaKINug=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
  ];
  buildInputs = [ libuuid ];

  meta = {
    homepage = "https://wiki.crosswire.org/BibleSync";
    description = "Multicast protocol to Bible software shared conavigation";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})

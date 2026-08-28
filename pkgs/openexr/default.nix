{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  imath,
  libdeflate,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "3.4.15";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    hash = "sha256-Z2o2ooDqAof5rnR5lX3RfWnklyD/c98HuwWF6uZA+78=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
    "doc"
  ];

  postPatch = ''
    cat <(find . -name tmpDir.h) <(echo src/test/OpenEXRCoreTest/main.cpp) | while read -r f ; do
      substituteInPlace $f --replace '/var/tmp' "$TMPDIR"
    done
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  propagatedBuildInputs = [
    imath
    libdeflate
  ];

  meta = {
    description = "High dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}

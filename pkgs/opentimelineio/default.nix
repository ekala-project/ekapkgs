{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  imath,
  rapidjson,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opentimelineio";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenTimelineIO";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PEqQraLx6wiJecytp37q15VayOn2fvaSlOeLs3qrRqo=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  propagatedBuildInputs = [
    imath
  ];

  buildInputs = [
    rapidjson
  ];

  cmakeEntries = {
    OTIO_DEPENDENCIES_INSTALL = false;
    OTIO_FIND_IMATH = true;
  };

  meta = {
    description = "Open Source API and interchange format for editorial timeline information";
    homepage = "https://github.com/AcademySoftwareFoundation/OpenTimelineIO";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})

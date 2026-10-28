{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fftw,
  catch2_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkeyfinder";
  version = "2.2.8";

  src = fetchFromGitHub {
    owner = "mixxxdj";
    repo = "libkeyfinder";
    tag = finalAttrs.version;
    hash = "sha256-Et8u5j/ke9u2bwHFriPCCBiXkPel37gwx+kwuViAr4o=";
  };

  nativeBuildInputs = [
    cmake.configurePhaseHook
    cmake
  ];

  buildInputs = [ fftw ];

  nativeCheckInputs = [ catch2_3 ];

  cmakeEntries = {
    FETCHCONTENT_FULLY_DISCONNECTED = true;
    FETCHCONTENT_SOURCE_DIR_CATCH2 = "${catch2_3.src}";
  };

  doCheck = true;

  meta = {
    description = "Musical key detection for digital audio (C++ library)";
    homepage = "https://mixxxdj.github.io/libkeyfinder/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})

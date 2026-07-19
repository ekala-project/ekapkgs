{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "utf8cpp";
  version = "4.0.9";

  src = fetchFromGitHub {
    owner = "nemtrif";
    repo = "utfcpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0FgMKHymFOA3BM7VS8US2is8TmQlL/wWj4nSRihqcDo=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "UTF8CPP_ENABLE_TESTS" false)
  ];

  meta = {
    homepage = "https://github.com/nemtrif/utfcpp";
    description = "UTF-8 with C++ in a Portable Way";
    license = lib.licenses.boost;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "string-view-lite";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "martinmoene";
    repo = "string-view-lite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WMWTrzkAex8gR1juvYdUhq1y6qSdxHowJK3EpjAlYbI=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
  ];

  doCheck = true;

  meta = {
    description = "C++17-like string_view for C++98, C++11 and later in a single-file header-only library";
    homepage = "https://github.com/martinmoene/string-view-lite";
    changelog = "https://github.com/martinmoene/string-view-lite/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.boost;
  };
})

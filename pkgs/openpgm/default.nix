{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openpgm";
  version = "5.3.128";

  src = fetchFromGitHub {
    owner = "steve-o";
    repo = "openpgm";
    tag = "release-${builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-jBIKUjMjcrFMNLpvbJo0Ym0IuvN6JQpmGfRalTrf3E4=";
  };

  sourceRoot = "${finalAttrs.src.name}/openpgm/pgm";

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    python3
  ];

  # Remove MSVC-specific /LTCG linker flags that break Linux builds
  postPatch = ''
    sed -i '/\/LTCG/d' CMakeLists.txt
  '';

  meta = {
    description = "Open source implementation of the Pragmatic General Multicast (PGM) specification";
    homepage = "https://github.com/steve-o/openpgm";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})

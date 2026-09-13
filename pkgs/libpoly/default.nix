{
  lib,
  stdenv,
  fetchFromGitHub,
  gmp,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpoly";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "libpoly";
    # they've pushed to the release branch, use explicit tag
    tag = "v${finalAttrs.version}";
    hash = "sha256-uDWDio+RzJrgGKbWfT6S6voaJrJR0PzPfyr+33dr0ds=";
  };

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-warn " -Werror " " "
    # Remove C++ (polyxx) targets — ekapkgs gmp lacks gmpxx.h
    sed -i '/^set(polyxx_SOURCES/,/^)/d' src/CMakeLists.txt
    sed -i '/add_library(polyxx /d' src/CMakeLists.txt
    sed -i '/set_target_properties(polyxx /,/^)/d' src/CMakeLists.txt
    sed -i '/target_link_libraries(polyxx /d' src/CMakeLists.txt
    sed -i '/install(TARGETS polyxx /d' src/CMakeLists.txt
    sed -i '/static_polyxx\|static_pic_polyxx/d' src/CMakeLists.txt
    sed -i '/test\/polyxx/d' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    python3
  ];

  buildInputs = [
    gmp
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/SRI-CSL/libpoly";
    description = "C library for manipulating polynomials";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.all;
  };
})

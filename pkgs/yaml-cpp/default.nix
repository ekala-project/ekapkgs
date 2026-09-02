{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yaml-cpp";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    rev = finalAttrs.version;
    hash = "sha256-J87oS6Az1/vNdyXu3L7KmUGWzU0IAkGrGMUUha+xDXI=";
  };

  patches = [
    (fetchpatch {
      name = "yaml-cpp-fix-cmake-4.patch";
      url = "https://github.com/jbeder/yaml-cpp/commit/c2680200486572baf8221ba052ef50b58ecd816e.patch";
      hash = "sha256-1kXRa+xrAbLEhcJxNV1oGHPmayj1RNIe6dDWXZA3mUA=";
    })
    (fetchpatch {
      name = "yaml-cpp-add-include-cstdint-gcc15.patch";
      url = "https://github.com/jbeder/yaml-cpp/commit/7b469b4220f96fb3d036cf68cd7bd30bd39e61d2.patch";
      hash = "sha256-4Mua6cYD8UR+fJfFeu0fdYVFprsiuF89HvbaTByz9nI=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    "-DYAML_CPP_BUILD_TOOLS=false"
    (lib.cmakeBool "YAML_BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    "-DINSTALL_GTEST=false"
  ];

  meta = {
    description = "YAML parser and emitter for C++";
    homepage = "https://github.com/jbeder/yaml-cpp";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jsoncpp";
  version = "1.9.8";

  strictDeps = true;
  __structuredAttrs = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    rev = finalAttrs.version;
    sha256 = "sha256-5cH9G4/TVCM5HX6QSk3P4m5+cwuK4x8hP9FohBcmjik=";
  };

  unpackPhase = ''
    cp -a ${finalAttrs.src} ${finalAttrs.src.name}
    chmod -R +w ${finalAttrs.src.name}
    export sourceRoot=${finalAttrs.src.name}
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    python3
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_OBJECT_LIBS=OFF"
    "-DJSONCPP_WITH_CMAKE_PACKAGE=ON"
    "-DBUILD_STATIC_LIBS=OFF"
  ];

  meta = {
    homepage = "https://github.com/open-source-parsers/jsoncpp";
    description = "C++ library for interacting with JSON";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})

{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  python3,
  flex,
  bison,
  libiconv,
  spdlog,
  fmt,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doxygen";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "doxygen";
    repo = "doxygen";
    tag = "Release_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-SSq/sFB9y2CFMeL58vgcHa2ulo+tPPUGT347ABoHoD4=";
  };

  # https://github.com/doxygen/doxygen/issues/10928#issuecomment-2179320509
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'JAVACC_CHAR_TYPE=\"unsigned char\"' \
                     'JAVACC_CHAR_TYPE=\"char8_t\"' \
      --replace-fail "CMAKE_CXX_STANDARD 17" "CMAKE_CXX_STANDARD 20"
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    python3
    flex
    bison
  ];

  buildInputs = [
    libiconv
    spdlog
    fmt
    sqlite
  ];

  cmakeFlags = [
    "-Duse_sys_spdlog=ON"
    "-Duse_sys_fmt=ON"
    "-Duse_sys_sqlite3=ON"
  ];

  # put examples in an output so people/tools can test against them
  outputs = [
    "out"
    "examples"
  ];

  postInstall = ''
    cp -r ../examples $examples
  '';

  meta = {
    license = lib.licenses.gpl2Plus;
    homepage = "https://www.doxygen.nl";
    changelog = "https://www.doxygen.nl/manual/changelog.html";
    description = "Source code documentation generator tool";
    mainProgram = "doxygen";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

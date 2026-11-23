{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libacars";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "szpajder";
    repo = "libacars";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z2wwHmZH0At8JsVdy0NFMnOHK0ibGAsp5kEg/yOwBFw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    CMAKE_INSTALL_LIBDIR = "lib";
  };

  meta = {
    homepage = "https://github.com/szpajder/libacars";
    description = "Aircraft Communications Addressing and Reporting System (ACARS) message decoder";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

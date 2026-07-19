{
  lib,
  stdenv,
  boost,
  fetchFromGitHub,
  cmake,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtorrent-rasterbar";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-JbNOKzB830VQkZjC8ZAmzbu/7nkAgyD8cOr22uYbIGQ=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    boost
    openssl
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace cmake/Modules/GeneratePkgConfig/target-compile-settings.cmake.in \
      --replace-fail \
        'set(_INSTALL_LIBDIR "@CMAKE_INSTALL_LIBDIR@")' \
        'set(_INSTALL_LIBDIR "@CMAKE_INSTALL_LIBDIR@")
         set(_INSTALL_FULL_LIBDIR "@CMAKE_INSTALL_FULL_LIBDIR@")'
    substituteInPlace cmake/Modules/GeneratePkgConfig/pkg-config.cmake.in \
      --replace-fail '$'{prefix}/@_INSTALL_LIBDIR@ @_INSTALL_FULL_LIBDIR@
  '';

  cmakeFlags = [
    (lib.cmakeBool "python-bindings" false)
  ];

  meta = {
    homepage = "https://libtorrent.org/";
    description = "Efficient feature complete C++ bittorrent implementation";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  python3,
  removeReferencesTo,
  enableModTool ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "volk";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "gnuradio";
    repo = "volk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9bURoGyjdNoKCcgGvZL9VygQqUQxOrwthp154Was2/s=";
    fetchSubmodules = true;
  };

  cmakeFlags = [ (lib.cmakeBool "ENABLE_MODTOOL" enableModTool) ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    python3
    python3.pkgs.mako
    removeReferencesTo
  ];

  postInstall = ''
    remove-references-to -t ${stdenv.cc} $(readlink -f "''${!outputLib}"/lib/libvolk${stdenv.hostPlatform.extensions.sharedLibrary})
  '';

  doCheck = true;

  meta = {
    homepage = "http://libvolk.org/";
    description = "Vector Optimized Library of Kernels";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lxqt-build-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-themes";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-themes";
    tag = finalAttrs.version;
    hash = "sha256-whMW4fMiIcL4Qb/VNynVGBTIyObTMlf6AaWCnBYikZI=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    lxqt-build-tools
  ];

  meta = {
    homepage = "https://github.com/lxqt/lxqt-themes";
    description = "Themes, graphics and icons for LXQt";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})

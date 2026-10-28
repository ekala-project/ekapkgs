{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  kdoctools,
  qt6,
  kdePackages,
  knotifyconfig,
  kwindowsystem,
  kstatusnotifieritem,
  ktextwidgets,
  kcrash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rsibreak";
  version = "0.13.0";

  src = fetchurl {
    url = "mirror://kde/stable/rsibreak/${lib.versions.majorMinor finalAttrs.version}/rsibreak-${finalAttrs.version}.tar.xz";
    hash = "sha256-arLOCcV9D+UXgwjqlfh9675VrpjPs3QkkireJZO60SA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    kdoctools
    qt6.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    knotifyconfig
    kdePackages.kidletime
    kwindowsystem
    kstatusnotifieritem
    ktextwidgets
    kcrash
  ];

  meta = {
    description = "Takes care of your health and regularly breaks your work to avoid repetitive strain injury (RSI)";
    mainProgram = "rsibreak";
    license = lib.licenses.gpl2;
    homepage = "https://www.kde.org/applications/utilities/rsibreak/";
  };
})

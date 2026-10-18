{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
  qt6,
  extra-cmake-modules,
  kcolorpicker,
  kimageannotator,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ksnip";
  version = "1.10.1-unstable-2026-02-27";

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "ksnip";
    rev = "f50e2764d0d51af2fd06c9d70f1e5f1631726975";
    hash = "sha256-XehTMbvSRHfwTy6+Rv2QavQfRs6lK1+sd04iOZZZH4c=";
  };

  cmakeEntries = {
    BUILD_WITH_QT6 = true;
    QT_FIND_PRIVATE_MODULES = true;
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    kcolorpicker
    kimageannotator
    qt6.qtsvg
  ];

  postPatch = ''
    substituteInPlace desktop/org.ksnip.ksnip.desktop \
      --replace-fail "Exec=/usr/bin/ksnip" "Exec=ksnip"
  '';

  meta = {
    homepage = "https://github.com/ksnip/ksnip";
    description = "Cross-platform screenshot tool with many annotation features";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ksnip";
  };
})

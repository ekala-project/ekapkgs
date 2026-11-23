# yaru — Ubuntu community theme
{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  sassc,
  pkg-config,
  glib,
  ninja,
  python3,
  gtk3,
  humanity-icon-theme,
  hicolor-icon-theme,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yaru";
  version = "26.10.3ubuntu";

  src = fetchFromGitHub {
    owner = "ubuntu";
    repo = "yaru";
    tag = finalAttrs.version;
    hash = "sha256-vkvHZAq9mGaKSQmylmey9BtuOXoJEdKb/gNebunz9Ug=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    sassc
    pkg-config
    glib
    python3
    gtk3
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    humanity-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postPatch = "patchShebangs .";

  meta = {
    description = "Ubuntu community theme 'yaru' — default Ubuntu theme since 18.10";
    homepage = "https://github.com/ubuntu/yaru";
    license = with lib.licenses; [
      cc-by-sa-40
      gpl3Plus
      lgpl21Only
      lgpl3Only
    ];
    platforms = lib.platforms.linux;
  };
})

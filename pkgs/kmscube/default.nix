{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  libdrm,
  libx11,
  libGL,
  libgbm,
  pkg-config,
  gstreamer,
}:

stdenv.mkDerivation {
  pname = "kmscube";
  version = "0-unstable-2023-09-25";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = "kmscube";
    rev = "96d63eb59e34c647cda1cbb489265f8c536ae055";
    hash = "sha256-kpnn4JBNvwatrcCF/RGk/fQ7qiKD26iLBr9ovDmAKBo=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    pkg-config
    ninja
  ];
  buildInputs = [
    libdrm
    libx11
    libGL
    libgbm
  ]
  ++ (with gstreamer; [
    gstreamer
    plugins-base
  ]);

  meta = {
    description = "Example OpenGL app using KMS/GBM";
    homepage = "https://gitlab.freedesktop.org/mesa/kmscube";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}

{
  lib,
  fetchFromGitHub,
  linuxHeaders,
  meson,
  ninja,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qbootctl";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "qbootctl";
    tag = finalAttrs.version;
    hash = "sha256-lpDCU9RJ4pK/qX4dEFfOCEdsF7l4Z/J8wzWMD4orFQY=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    linuxHeaders
  ];

  env.CFLAGS = toString [ "-I${linuxHeaders}/include" ];
  meta = {
    homepage = "https://github.com/linux-msm/qbootctl";
    description = "Qualcomm bootctl HAL for Linux";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "qbootctl";
  };
})

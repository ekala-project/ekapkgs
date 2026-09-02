{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eglexternalplatform";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "eglexternalplatform";
    tag = finalAttrs.version;
    hash = "sha256-tDKh1oSnOSG/XztHHYCwg1tDB7M6olOtJ8te+uan9ko=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
  ];

  strictDeps = true;

  meta = {
    description = "EGL External Platform interface";
    homepage = "https://github.com/NVIDIA/eglexternalplatform";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})

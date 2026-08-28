{
  stdenv,
  lib,
  fetchFromGitHub,
  hidapi,
  udev,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hidapitester";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "todbot";
    repo = "hidapitester";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WqyAaoiiuHbLAgfGpl4M3AHyWFl8KPGA/OaO2E/uix0=";
  };

  postUnpack = ''
    cp --no-preserve=mode -r ${hidapi.src} hidapi
    export HIDAPI_DIR=$PWD/hidapi
  '';

  env.HIDAPITESTER_VERSION = finalAttrs.version;

  buildInputs = [
    udev
    hidapi
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 hidapitester $out/bin/hidapitester
    runHook postInstall
  '';

  meta = {
    description = "Simple command-line program to test HIDAPI";
    homepage = "https://github.com/todbot/hidapitester";
    changelog = "https://github.com/todbot/hidapitester/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "hidapitester";
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  systemd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qmk_hid";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "qmk_hid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wJi7FQrvMbdTwvbbjBnzmxupMbEuM8TeZ0JIK5ulQKI=";
  };

  cargoHash = "sha256-ytg4pgPzl9dKyCWgRRVRg1noNRvBhBnWNf9bmNcHnjY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    systemd
  ];

  checkFlags = [
    "--skip=src/lib.rs"
  ];

  meta = {
    description = "Commandline tool for interacting with QMK devices over HID";
    homepage = "https://github.com/FrameworkComputer/qmk_hid";
    license = lib.licenses.bsd3;
    mainProgram = "qmk_hid";
  };
})

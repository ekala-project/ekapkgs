{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  gtest,
  meson,
  nasm,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openh264";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "openh264";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tf0lnxATCkoq+xRti6gK6J47HwioAYWnpEsLGSA5Xdg=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    (fetchpatch {
      name = "freebsd-configure.patch";
      url = "https://github.com/cisco/openh264/commit/ea8a1ad5791ee5c4e2ecf459aec235128d69b35b.patch";
      hash = "sha256-pJvh9eRxFZQ+ob4WPu/x+jr1CCpgnug1uBViLfAtBDg=";
    })
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    nasm
    ninja
    pkg-config
  ];

  buildInputs = [
    gtest
  ];

  strictDeps = true;

  meta = {
    description = "Codec library which supports H.264 encoding and decoding";
    homepage = "https://www.openh264.org";
    changelog = "https://github.com/cisco/openh264/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    platforms = lib.intersectLists (
      lib.platforms.x86
      ++ lib.platforms.arm
      ++ lib.platforms.aarch64
      ++ lib.platforms.loongarch64
      ++ lib.platforms.riscv64
    ) lib.platforms.unix;
  };
})

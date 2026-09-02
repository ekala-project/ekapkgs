{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  openssl,
  ding-libs,
  talloc,
  popt,
  help2man,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sscg";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "sgallagher";
    repo = "sscg";
    tag = "sscg-${finalAttrs.version}";
    hash = "sha256-0t3ntUxfh1jFukWGwmdbt0axFfUiH1QEq6wFrGoI7Jk=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    pkg-config
    ninja
  ];

  buildInputs = [
    openssl
    ding-libs
    talloc
    popt
    help2man
  ];

  meta = {
    description = "Simple Signed Certificate Generator";
    homepage = "https://github.com/sgallagher/sscg";
    changelog = "https://github.com/sgallagher/sscg/blob/sscg-${finalAttrs.version}";
    license = lib.licenses.gpl3;
    mainProgram = "sscg";
  };
})

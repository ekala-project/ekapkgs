{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "termpaint";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "termpaint";
    repo = "termpaint";
    rev = finalAttrs.version;
    hash = "sha256-7mfGTC5vJ4806bDbrPMSVthtW05a+M3vgUlHGbtaI4Q=";
  };

  patches = [ ./0001-meson.build-use-prefix.patch ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
  ];

  mesonEntries = {
    ttyrescue-fexec-blob = false;
    tools-path = "libexec/";
    ttyrescue-path = "libexec/";
    ttyrescue-install = true;
  };

  doCheck = true;

  meta = {
    description = "Low level terminal interface library";
    homepage = "https://github.com/termpaint/termpaint";
    platforms = lib.platforms.unix;
    license = lib.licenses.boost;
  };
})

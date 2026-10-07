{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  sdl2-compat,
  perl,
  pkg-config,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jfsw";
  version = "20260105";

  src = fetchFromGitHub {
    owner = "jonof";
    repo = "jfsw";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-L/EtdbyU6uZbSajQkI8IclskIfzm15uikSK2EZZZHXA=";
  };

  nativeBuildInputs = [
    which
    sdl2-compat
    perl
    pkg-config
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    sdl2-compat
    gtk3
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 sw -t $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Modern port the original Shadow Warrior";
    homepage = "http://www.jonof.id.au/jfsw/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "sw";
    broken = stdenv.hostPlatform.isDarwin;
    inherit (sdl2-compat.meta) platforms;
  };
})

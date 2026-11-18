{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  espeak-ng ? null,
  withSpeech ? (espeak-ng != null),
}:

buildGoModule (finalAttrs: {
  pname = "mob";
  version = "5.4.4";

  src = fetchFromGitHub {
    owner = "remotemobprogramming";
    repo = "mob";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WVT0VI7aZTROW1dgwFl0JerlFZZZVVCG/RAlXtvofZs=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  preFixup = lib.optionalString withSpeech ''
    wrapProgram $out/bin/mob \
      --set MOB_VOICE_COMMAND "${lib.getBin espeak-ng}/bin/espeak"
  '';

  meta = {
    description = "Tool for smooth git handover";
    mainProgram = "mob";
    homepage = "https://github.com/remotemobprogramming/mob";
    license = lib.licenses.mit;
  };
})

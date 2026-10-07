{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gowitness";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = "gowitness";
    tag = finalAttrs.version;
    hash = "sha256-sdCJsDXpDTIi/fI7sQv+hRyOaiAO/78oetJ1SFJa80o=";
  };

  vendorHash = "sha256-vrofb4b4mQCjJoauMYdsQyMM3BOcOOesMT+6Jlm6bMo=";

  ldflags = [
    "-s"
    "-w"
  ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Web screenshot utility";
    homepage = "https://github.com/sensepost/gowitness";
    changelog = "https://github.com/sensepost/gowitness/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "gowitness";
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  makeWrapper,
  nodejs,
  curl,
  versionCheckHook,
}:

stdenv.mkDerivation {
  pname = "codex-auth";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "loongphy";
    repo = "codex-auth";
    tag = "v0.3.0";
    hash = "sha256-TrJtVP4gRdupx6StKWc2PIXoVnnlFMUqFw6JtEmWqZ4=";
  };

  nativeBuildInputs = [
    zig.hook
    makeWrapper
  ];


  doCheck = true;
  nativeCheckInputs = [ curl ];

  postInstall = ''
    wrapProgram $out/bin/codex-auth \
      --set CODEX_AUTH_NODE_EXECUTABLE ${lib.getExe nodejs} \
      --prefix PATH : ${lib.makeBinPath [ curl ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "CLI tool for switching Codex accounts";
    homepage = "https://github.com/loongphy/codex-auth";
    changelog = "https://github.com/loongphy/codex-auth/releases/tag/v0.3.0";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "codex-auth";
    platforms = lib.platforms.unix;
  };
}

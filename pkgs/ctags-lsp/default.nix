{
  buildGo126Module,
  fetchFromGitHub,
  git,
  jujutsu ? null,
  lib,
  makeWrapper,
  universal-ctags,
}:
buildGo126Module (finalAttrs: {
  pname = "ctags-lsp";
  version = "0.10.2";
  vendorHash = null;

  src = fetchFromGitHub {
    owner = "netmute";
    repo = "ctags-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8cknVcXIuV7mmRMm87jn2l3qrfaY3CGzCZ0VW5Vb9xk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/ctags-lsp \
      --suffix PATH : ${
        lib.makeBinPath (
          [
            universal-ctags
            git
          ]
          ++ lib.optionals (jujutsu != null) [
            jujutsu
          ]
        )
      }
  '';

  meta = {
    changelog = "https://github.com/netmute/ctags-lsp/releases/tag/v${finalAttrs.version}";
    description = "LSP implementation using universal-ctags as backend";
    homepage = "https://github.com/netmute/ctags-lsp";
    license = lib.licenses.mit;
    mainProgram = "ctags-lsp";
    maintainers = [ ];
  };
})

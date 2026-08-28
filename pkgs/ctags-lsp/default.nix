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
  version = "0.11.0";
  vendorHash = null;

  src = fetchFromGitHub {
    owner = "netmute";
    repo = "ctags-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9VKXdffK46gl7MLN1kpSpQRIoJzu4nTS9C1r//qsOuo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # Tests require a functioning LSP server setup with writer initialization
  # that doesn't work in the Nix sandbox (nil pointer in sendResponse)
  doCheck = false;

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
  };
})

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "age";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A1VUzovKWxwelSc9/xofBwTfbRil9t75fRavb5p2JlA=";
  };

  vendorHash = "sha256-cNh9U7OjoxewskX/+Ezln+U7p44g2h+Zx1dVKAaK6Ww=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preInstall = ''
    installManPage doc/*.1
  '';

  # plugin test is flaky
  checkFlags = [
    "-skip"
    "TestScript/plugin"
  ];

  meta = {
    changelog = "https://github.com/FiloSottile/age/releases/tag/v${finalAttrs.version}";
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = lib.licenses.bsd3;
    mainProgram = "age";
  };
})

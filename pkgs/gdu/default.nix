{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "gdu";
  version = "5.37.0";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = "gdu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V5Icy4A6hpvNErxroxnzeUNtBHLxeT8QJPpEGmLvWmM=";
  };

  vendorHash = "sha256-M7KqrXMkiQnmoN3yYGSIyQkwC5b0+e8yJQ5d8WmFtZY=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/dundee/gdu/v${lib.versions.major finalAttrs.version}/build.Version=${finalAttrs.version}"
  ];

  postPatch = ''
    substituteInPlace cmd/gdu/app/app_test.go \
      --replace-fail "development" "${finalAttrs.version}"
  '';

  postInstall = ''
    installManPage gdu.1
  '';

  doCheck = false;

  meta = {
    description = "Disk usage analyzer with console interface";
    homepage = "https://github.com/dundee/gdu";
    changelog = "https://github.com/dundee/gdu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "gdu";
    maintainers = [ ];
  };
})

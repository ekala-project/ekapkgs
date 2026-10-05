{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  bubblewrap,
  socat,
  testers,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "fence";
  version = "0.1.67";

  src = fetchFromGitHub {
    owner = "fencesandbox";
    repo = "fence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vl9xKiDpm4CC1LcYiOeQKawgxM69BzILXflNnpMRhH8=";
  };

  vendorHash = "sha256-Dn6nc2i/tmm6Zrqge1r1ezi+WY/I8GU9m7x1cBKeY80=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  subPackages = [ "cmd/fence" ];

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.buildTime=1970-01-01T00:00:00Z"
    "-X=main.gitCommit=v${finalAttrs.version}"
  ];

  postInstall = ''
    installShellCompletion --cmd fence \
      --bash <($out/bin/fence completion bash) \
      --fish <($out/bin/fence completion fish) \
      --zsh <($out/bin/fence completion zsh)
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/fence \
      --prefix PATH : ${
        lib.makeBinPath [
          bubblewrap
          socat
          # TODO(corepkgs): add bpftrace to the runtime PATH
        ]
      }
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Sandbox for running AI coding agents with filesystem and network isolation";
    homepage = "https://github.com/fencesandbox/fence";
    changelog = "https://github.com/fencesandbox/fence/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "fence";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

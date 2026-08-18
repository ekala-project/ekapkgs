{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bottom";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = "bottom";
    tag = finalAttrs.version;
    hash = "sha256-+VfXxLKIdrg+ytmx29TPm46t3yhAgqBSJ+ykiIjuNmA=";
  };

  cargoHash = "sha256-dvU/iAgLC0+l8FH1bnOdIvZrXHqltE1hMkf+IaLQZxE=";

  nativeBuildInputs = [
    installShellFiles
  ];

  doCheck = false;

  env = {
    BTM_GENERATE = true;
  };

  postInstall = ''
    installManPage target/tmp/bottom/manpage/btm.1
    installShellCompletion \
      target/tmp/bottom/completion/btm.{bash,fish} \
      --zsh target/tmp/bottom/completion/_btm

    install -Dm444 desktop/bottom.desktop -t $out/share/applications
    install -Dm644 assets/icons/bottom-system-monitor.svg -t $out/share/icons/hicolor/scalable/apps
  '';

  meta = {
    changelog = "https://github.com/ClementTsang/bottom/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Cross-platform graphical process/system monitor with a customizable interface";
    homepage = "https://github.com/ClementTsang/bottom";
    license = lib.licenses.mit;
    mainProgram = "btm";
    maintainers = [ ];
  };
})

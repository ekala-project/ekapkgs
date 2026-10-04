{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bottom";
  version = "0.14.9";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = "bottom";
    tag = finalAttrs.version;
    hash = "sha256-Dvo3A8NIYp0URgYSJOxLW/zEA7Gnpqu9pk6hvpagFZE=";
  };

  cargoHash = "sha256-PYbmqiE8G+or1NEtPxnWIXcHnKIBSjQ3FN/Zafb/BTw=";

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
  };
})

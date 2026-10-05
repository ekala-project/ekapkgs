{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

let
  mainProgram = "pinact";
in
buildGoModule (finalAttrs: {
  pname = "pinact";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = "pinact";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VmLQmZDFBweh8O6VHcDQsAc6Ojcriw0oQymO6SkAVpU=";
  };

  vendorHash = "sha256-mAlwYacDZruLw9hMr77z6MYNPME+iPntJROK6Yd84uI=";

  env.CGO_ENABLED = 0;

  doCheck = true;

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd '${mainProgram}' \
      --bash <("$out/bin/${mainProgram}" completion bash) \
      --zsh <("$out/bin/${mainProgram}" completion zsh) \
      --fish <("$out/bin/${mainProgram}" completion fish)
  '';

  nativeInstallCheckInputs = [
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${mainProgram}";
  versionCheckProgramArg = "version";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version} -X main.commit=v${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/pinact"
  ];

  meta = {
    inherit mainProgram;
    description = "Pin GitHub Actions versions";
    homepage = "https://github.com/suzuki-shunsuke/pinact";
    changelog = "https://github.com/suzuki-shunsuke/pinact/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
  };
})

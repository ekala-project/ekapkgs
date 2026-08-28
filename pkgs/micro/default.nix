{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "micro";
  version = "2.0.15";

  src = fetchFromGitHub {
    owner = "micro-editor";
    repo = "micro";
    rev = "v${version}";
    hash = "sha256-4C6TtMU6PIYX7lO+o4GRVnIsKnYJxjAqPdoOyAwi7Gc=";
  };

  vendorHash = "sha256-bkPd6zB9e4q6N20wbKS8n8zGGITOoScajdPYv7Race0=";
  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  outputs = [
    "out"
    "man"
  ];

  subPackages = [ "cmd/micro" ];

  ldflags =
    let
      t = "github.com/zyedidia/micro/v2/internal";
    in
    [
      "-s"
      "-w"
      "-X ${t}/util.Version=${version}"
      "-X ${t}/util.CommitHash=${src.rev}"
    ];

  strictDeps = true;

  preBuild = ''
    GOOS= GOARCH= go generate ./runtime
  '';

  postInstall = ''
    installManPage assets/packaging/micro.1
    install -Dm444 assets/packaging/micro.desktop $out/share/applications/micro.desktop
    install -Dm644 assets/micro-logo-mark.svg $out/share/icons/hicolor/scalable/apps/micro.svg
  '';

  meta = {
    homepage = "https://micro-editor.github.io";
    description = "Modern and intuitive terminal-based text editor";
    license = lib.licenses.mit;
    mainProgram = "micro";
  };
}

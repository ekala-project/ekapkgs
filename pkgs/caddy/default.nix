{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGo126Module (finalAttrs: {
  pname = "caddy";
  version = "2.11.4";

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = "caddy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wzk8KRZfDCbbjRlBwkoKAoMjOhV4xF3yuXUueqtl1xM=";
  };

  vendorHash = "sha256-2GwSM7EKN9GwN6kte7CekpXIJ0vzHhhsnrs3TC6vTW4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/caddyserver/caddy/v2.CustomVersion=${finalAttrs.version}"
  ];

  tags = [
    "nobadger"
    "nomysql"
    "nopgx"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall = ''
    install -Dm644 ${finalAttrs.passthru.dist}/init/caddy.service ${finalAttrs.passthru.dist}/init/caddy-api.service -t $out/lib/systemd/system

    substituteInPlace $out/lib/systemd/system/caddy.service \
      --replace-fail "/usr/bin/caddy" "$out/bin/caddy"
    substituteInPlace $out/lib/systemd/system/caddy-api.service \
      --replace-fail "/usr/bin/caddy" "$out/bin/caddy"

    $out/bin/caddy manpage --directory manpages
    installManPage manpages/*

    installShellCompletion --cmd caddy \
      --bash <($out/bin/caddy completion bash) \
      --fish <($out/bin/caddy completion fish) \
      --zsh <($out/bin/caddy completion zsh)
  '';

  passthru = {
    dist = fetchFromGitHub {
      owner = "caddyserver";
      repo = "dist";
      tag = "v${finalAttrs.version}";
      hash = "sha256-oRQfQH1GKjAjVMj+dZo1f1+HOaOdJIyEfod0iGLYcc8=";
    };
  };

  meta = {
    homepage = "https://caddyserver.com";
    description = "Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS";
    changelog = "https://github.com/caddyserver/caddy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "caddy";
  };
})

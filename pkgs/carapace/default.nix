{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "carapace";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "carapace-sh";
    repo = "carapace-bin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KO+fD81PyIK8gcNQfeyQgn6YMGSSvndyU4Efu5ZQZxE=";
  };

  vendorHash = "sha256-6Pm1lsRGiY3tfEV9T17SX5ZEssIyRWyrjgKlOlUzcZQ=";

  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "./cmd/carapace" ];

  tags = [ "release" ];

  preBuild = ''
    GOOS= GOARCH= go generate ./...
  '';

  doCheck = false;

  meta = {
    description = "Multi-shell multi-command argument completer";
    homepage = "https://carapace.sh/";
    license = lib.licenses.mit;
    mainProgram = "carapace";
  };
})

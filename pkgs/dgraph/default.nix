{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  jemalloc,
  nodejs,
}:

buildGoModule rec {
  pname = "dgraph";
  version = "25.1.0";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
    sha256 = "sha256-0i3i0XPOS7v2DsO/tPJQSWJ3Yf8uz8aR1j+Mgm/QJUs=";
  };

  vendorHash = "sha256-3OwXBt0EwMk3jVny2Cs1NbGdeUy8MxDntZAn+mceKC8=";

  doCheck = false;

  ldflags = [
    "-X github.com/dgraph-io/dgraph/x.dgraphVersion=${version}-oss"
  ];

  tags = [ "oss" ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    jemalloc
    nodejs
  ];

  subPackages = [ "dgraph" ];

  postInstall = ''
    for shell in bash zsh; do
      $out/bin/dgraph completion $shell > dgraph.$shell
      installShellCompletion dgraph.$shell
    done
  '';

  meta = {
    homepage = "https://dgraph.io/";
    description = "Fast, Distributed Graph DB";
    # Apache 2.0 because only the "oss" build is used
    license = lib.licenses.asl20;
    mainProgram = "dgraph";
  };
}

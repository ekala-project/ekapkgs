{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  jemalloc,
  nodejs,
}:

buildGoModule (finalAttrs: {
  pname = "dgraph";
  version = "25.1.0";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-0i3i0XPOS7v2DsO/tPJQSWJ3Yf8uz8aR1j+Mgm/QJUs=";
  };

  vendorHash = "sha256-3OwXBt0EwMk3jVny2Cs1NbGdeUy8MxDntZAn+mceKC8=";

  ldflags = [
    "-X github.com/dgraph-io/dgraph/x.dgraphVersion=${finalAttrs.version}-oss"
  ];

  tags = [ "oss" ];

  nativeBuildInputs = [
    installShellFiles
    nodejs
  ];

  buildInputs = [ jemalloc ];

  subPackages = [ "dgraph" ];

  postInstall = ''
    for shell in bash zsh; do
      $out/bin/dgraph completion $shell > dgraph.$shell
      installShellCompletion dgraph.$shell
    done
  '';

  meta = {
    homepage = "https://dgraph.io/";
    description = "Distributed graph database";
    # Apache 2.0 because only the "oss" build is used
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "dgraph";
  };
})

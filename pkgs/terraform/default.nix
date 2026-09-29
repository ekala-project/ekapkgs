{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  coreutils,
  installShellFiles,
}:

buildGoModule {
  pname = "terraform";
  version = "1.15.9";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform";
    rev = "v1.15.9";
    hash = "sha256-3awEA6qML/WM9OFzdlp1eFUTxbcIFP7ZnFU4AQN0PQ8=";
  };

  vendorHash = "sha256-V7UHC9r0HzrjCxBiiczUUP4+jiJXmw82UCmY7lJoExs=";

  # Set CGO_ENABLED based on platform:
  # - Linux: CGO_ENABLED=0 for static linking (avoids LTO plugin issues)
  # - Darwin: CGO_ENABLED=1 to avoid DNS resolution issues
  # See: https://github.com/hashicorp/terraform/blob/main/BUILDING.md
  env.CGO_ENABLED = if stdenv.hostPlatform.isDarwin then "1" else "0";

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/hashicorp/terraform/version.dev=no'"
  ];

  postPatch = ''
    # Between go 1.23 and 1.24 the following GODEBUG setting was removed, and a new
    # similar one was added.
    # https://github.com/golang/go/issues/72111
    substituteInPlace go.mod \
      --replace-quiet 'godebug tlskyber=0' 'godebug tlsmlkem=0'
  '';

  postConfigure = ''
    # speakeasy hardcodes /bin/stty https://github.com/bgentry/speakeasy/issues/22
    substituteInPlace vendor/github.com/bgentry/speakeasy/speakeasy_unix.go \
      --replace-fail "/bin/stty" "${coreutils}/bin/stty"
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    # https://github.com/posener/complete/blob/9a4745ac49b29530e07dc2581745a218b646b7a3/cmd/install/bash.go#L8
    installShellCompletion --bash --name terraform <(echo complete -C terraform terraform)
  '';

  preCheck = ''
    export HOME=$TMPDIR
    export TF_SKIP_REMOTE_TESTS=1
  '';

  subPackages = [ "." ];

  meta = {
    description = "Tool for building, changing, and versioning infrastructure";
    homepage = "https://www.terraform.io/";
    changelog = "https://github.com/hashicorp/terraform/blob/v1.15.9/CHANGELOG.md";
    license = lib.licenses.bsl11;
    mainProgram = "terraform";
  };
}

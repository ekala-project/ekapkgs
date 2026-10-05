{
  lib,
  buildGoModule,
  fetchFromGitHub,
  dolt,
  icu,
  makeWrapper,
  pkg-config,
  testers,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "beads";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "gastownhall";
    repo = "beads";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k3WUy0FWPoO7Ymu+FFgS2yYZ4u10Fb7mPBYqs17IP2U=";
  };

  vendorHash = "sha256-mnQo3S7JLrx0nY5EIP3qQVqWLTlisYhjJFzqgPD/xu8=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [ icu ];

  # go-icu-regex's cgo directives use raw -licui18n etc. with no
  # `#cgo pkg-config:` line, so pkg-config never runs; pass the icu include
  # and library paths explicitly.
  env = {
    CGO_ENABLED = "1";
    CGO_CFLAGS = "-I${lib.getDev icu}/include";
    CGO_CXXFLAGS = "-I${lib.getDev icu}/include";
    CGO_LDFLAGS = "-L${lib.getLib icu}/lib";
  };

  subPackages = [ "cmd/bd" ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/bd \
      --prefix PATH : ${lib.makeBinPath [ dolt ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Distributed issue tracker designed for AI-supervised coding workflows";
    homepage = "https://github.com/gastownhall/beads";
    changelog = "https://github.com/gastownhall/beads/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "bd";
    platforms = lib.platforms.unix;
  };
})

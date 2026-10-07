{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "sq";
  version = "0.55.0";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = "sq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RTRjLsaF34BE91KaU8JcMoFZSxeU+lU7z6BAEQCmxnk=";
  };

  vendorHash = "sha256-X/0fDqw37n8gPtkjB/Z13tDwJvk2qVCIj8bxgJVUhWE=";

  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  # Some tests violate sandbox constraints.
  doCheck = false;

  ldflags = [
    "-s"
    "-X=github.com/neilotoole/sq/cli/buildinfo.Version=v${finalAttrs.version}"
    "-X=github.com/neilotoole/sq/cli/buildinfo.Commit=${finalAttrs.src.rev}"
    "-X=github.com/neilotoole/sq/cli/buildinfo.Timestamp=1970-01-01T00:00:00Z"
  ];

  postInstall = ''
    for sh in bash fish zsh; do
      installShellCompletion --cmd sq --$sh <($out/bin/sq completion $sh)
    done
  '';

  meta = {
    description = "Swiss army knife for data";
    homepage = "https://sq.io/";
    changelog = "https://github.com/neilotoole/sq/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "sq";
  };
})

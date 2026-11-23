{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  gopass ? null,
}:

buildGoModule (finalAttrs: {
  pname = "git-credential-gopass";
  version = "1.17.5";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "git-credential-gopass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MyzjlpBSOVlyIP3+4KiDxUWaTU1RpiURPya0lL3LRV4=";
  };

  vendorHash = "sha256-lvFV+bBRTaN8YOhlHdFW+1x8aIIczrfk1ODbT0dXcWs=";

  subPackages = [ "." ];

  nativeBuildInputs = [
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
  ];

  postFixup = lib.optionalString (gopass != null) ''
    wrapProgram $out/bin/git-credential-gopass \
      --prefix PATH : "${gopass.wrapperPath}"
  '';

  meta = {
    description = "Manage git credentials using gopass";
    homepage = "https://github.com/gopasspw/git-credential-gopass";
    changelog = "https://github.com/gopasspw/git-credential-gopass/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "git-credential-gopass";
  };
})

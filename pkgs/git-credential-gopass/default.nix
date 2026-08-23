{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  makeWrapper,
  gopass ? null,
}:

buildGo126Module (finalAttrs: {
  pname = "git-credential-gopass";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "git-credential-gopass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IEur3Sw2zRYJxlwAhgpb2OnBt+FcC+OdeT7M/LzJwoY=";
  };

  vendorHash = "sha256-mtJIm7dH3jP7p0R0KxN0Yf7mi9rkJ73u8biy2Ygvk3k=";

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
    maintainers = [ ];
    mainProgram = "git-credential-gopass";
  };
})

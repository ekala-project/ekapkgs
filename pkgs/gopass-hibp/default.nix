{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  makeWrapper,
  gopass,
}:

buildGo126Module (finalAttrs: {
  pname = "gopass-hibp";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-hibp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BlZxXN14bOO7LMdjS/ooqVKmRZQTpNYlYp4A4rTew4Q=";
  };

  vendorHash = "sha256-LUmxstDE0paYaNS2Em1Xc6pJmHHWk/IJEjTZXq5qWW8=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/gopass-hibp \
      --prefix PATH : "${gopass.wrapperPath}"
  '';

  meta = {
    description = "Gopass haveibeenpwnd.com integration";
    homepage = "https://github.com/gopasspw/gopass-hibp";
    changelog = "https://github.com/gopasspw/gopass-hibp/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "gopass-hibp";
  };
})

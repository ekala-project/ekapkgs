{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mkbrr";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "mkbrr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cf//tThJeiE2h2W/5HgUWgmMDfn2pwIOBuOSKgz1RB0=";
  };

  vendorHash = "sha256-zf6gaOGcx00/5v+iU0jUKLHctFBWld9bSCZMUU+kTZU=";

  # gui subpackage is a separate module with CGO/GUI dependencies
  subPackages = [
    "."
    "./cmd"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
    "-X main.buildTime=unknown"
  ];

  doCheck = true;

  doInstallCheck = true;

  nativeInstallCheckInputs = [
  ];

  versionCheckProgramArg = "version";

  meta = {
    description = "Tool to create, modify and inspect torrent files";
    homepage = "https://github.com/autobrr/mkbrr";
    license = lib.licenses.gpl2Plus;
    mainProgram = "mkbrr";
  };
})

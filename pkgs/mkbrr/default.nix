{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mkbrr";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "mkbrr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6T7/HrCXMVun1Q+ZlBSGbV/ct88BVuf/I4KzdER5XGg=";
  };

  vendorHash = "sha256-xvDgEN3FeSDmKtO66+8MLVW0cL9zHijk6XugeWGJxCA=";

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

{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  exiftool,
}:
let
  version = "1.6.1";
  tag = "v${version}";
in
buildGoModule {
  pname = "superfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    inherit tag;
    hash = "sha256-YZXCowWe0R9LiNcBPWZiznnLWyPnjBnROsE2wUjJowY=";
  };

  vendorHash = "sha256-L4lA3TnsPpFxcEw+lzJE6WkFSBzUCrw7WTNAZNB7OGU=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ exiftool ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # Upstream notes that this could be flaky, and it consistently fails for me.
  checkFlags = [
    "-skip=^TestReturnDirElement/Sort_by_Date$"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Only failing on nix darwin. I suspect this is due to the way
    # darwin handles file permissions.
    "-skip=^TestCompressSelectedFiles"
  ];

  meta = {
    description = "Pretty fancy and modern terminal file manager";
    homepage = "https://github.com/yorukot/superfile";
    changelog = "https://github.com/yorukot/superfile/blob/${tag}/changelog.md";
    license = lib.licenses.mit;
    mainProgram = "superfile";
  };
}

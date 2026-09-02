{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  versionToTimestamp =
    version:
    let
      splitTS = builtins.elemAt (builtins.split "(.*)(T.*)" version) 1;
    in
    builtins.concatStringsSep "" [
      (builtins.elemAt splitTS 0)
      (builtins.replaceStrings [ "-" ] [ ":" ] (builtins.elemAt splitTS 1))
    ];

  versionToYear = version: builtins.elemAt (lib.splitString "-" version) 0;
in
buildGoModule (finalAttrs: {
  pname = "minio";
  version = "2025-10-15T17-29-55Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${finalAttrs.version}";
    hash = "sha256-HbjmCJYkWyRRHKriLP6QohaXYLk3QEVfi32Krq3ujjo=";
  };

  vendorHash = "sha256-BFnTJE9QFWmPsx90hDTG8MusdnwaBPYJxM5bCFk3hew=";

  doCheck = false;

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  tags = [ "kqueue" ];

  ldflags =
    let
      t = "github.com/minio/minio/cmd";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${versionToTimestamp finalAttrs.version}"
      "-X ${t}.CopyrightYear=${versionToYear finalAttrs.version}"
      "-X ${t}.ReleaseTag=RELEASE.${finalAttrs.version}"
      "-X ${t}.CommitID=${finalAttrs.src.rev}"
    ];

  meta = {
    homepage = "https://www.minio.io/";
    description = "S3-compatible object storage server";
    changelog = "https://github.com/minio/minio/releases/tag/RELEASE.${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "minio";
  };
})

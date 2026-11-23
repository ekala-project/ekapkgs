{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dbmate";
  version = "2.38.2";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mDdfKAkguNQPnk2cRAxAc2S47CSy4B85lopLWqd8fZQ=";
  };

  vendorHash = "sha256-xsOz0OtvgDi9ztEMMuraVIlAq3EoqVFiwfImfmWRuz8=";

  tags = [ "fts5" ];

  meta = {
    description = "Database migration tool";
    mainProgram = "dbmate";
    homepage = "https://github.com/amacneil/dbmate";
    changelog = "https://github.com/amacneil/dbmate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
  };
})

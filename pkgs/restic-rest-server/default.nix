{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "restic-rest-server";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "rest-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cWnZ91mrllhTlCLb+BoJMXqUON2wOWCqVShg+NKU7gs=";
  };

  vendorHash = "sha256-Fg8dDqehART535LYEOLazQntUAKxv9nmBN1RByW4OYE=";
  meta = {
    changelog = "https://github.com/restic/rest-server/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "High performance HTTP server that implements restic's REST backend API";
    mainProgram = "rest-server";
    homepage = "https://github.com/restic/rest-server";
    license = lib.licenses.bsd2;
  };
})

{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "ergo";
  version = "2.19.1";

  src = fetchFromGitHub {
    owner = "ergochat";
    repo = "ergo";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-yzGLOpECalSOv1zBpVkyDlHGaHSsQNsAoNa2jgLpsgM=";
  };

  vendorHash = null;

  meta = {
    changelog = "https://github.com/ergochat/ergo/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Modern IRC server (daemon/ircd) written in Go";
    mainProgram = "ergo";
    homepage = "https://github.com/ergochat/ergo";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})

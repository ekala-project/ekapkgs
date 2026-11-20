{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "lsh";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "latitudesh";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-IZysQ/IlxepXZnRkjayiCt/BMe8C8qaanzN+yETsZcE=";
  };

  vendorHash = "sha256-FbqoG1UDqMppDnNwVwr3yRvJn+UCr/LEh/XjrLwLoPA=";

  subPackages = [ "." ];

  meta = {
    changelog = "https://github.com/latitudesh/cli/releases/tag/v${finalAttrs.version}";
    description = "Command-Line Interface for Latitude.sh";
    homepage = "https://github.com/latitudesh/cli";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

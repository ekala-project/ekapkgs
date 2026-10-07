{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "webdav";
  version = "5.17.0";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rH/4xQkfHEtMG4BhpUacqlUzuhbgDgj3ZwleuE4A9M0=";
  };

  vendorHash = "sha256-igZa18NV7L3aj2CGhhn7LvnqnpVrMQJLhxZ7A321SXE=";

  meta = {
    description = "Simple WebDAV server";
    homepage = "https://github.com/hacdias/webdav";
    changelog = "https://github.com/hacdias/webdav/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "webdav";
  };
})

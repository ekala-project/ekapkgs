{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "webhook";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "adnanh";
    repo = "webhook";
    tag = finalAttrs.version;
    sha256 = "sha256-P+uLVv0YMlTXrbWVapXRXc+VvQZxUiimLG0EX9tDxpM=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  meta = {
    description = "Incoming webhook server that executes shell commands";
    mainProgram = "webhook";
    homepage = "https://github.com/adnanh/webhook";
    license = lib.licenses.mit;
  };
})

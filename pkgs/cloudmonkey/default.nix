{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "cloudmonkey";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "cloudstack-cloudmonkey";
    rev = finalAttrs.version;
    sha256 = "sha256-4GHfWKt9Igi+Sp8WUfriS4ad3q0k46+pE6qAmrb/Bms=";
  };

  vendorHash = null;

  meta = {
    description = "CLI for Apache CloudStack";
    homepage = "https://github.com/apache/cloudstack-cloudmonkey";
    license = lib.licenses.asl20;
    mainProgram = "cloudstack-cloudmonkey";
  };

})

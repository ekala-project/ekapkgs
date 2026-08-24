{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hey";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "rakyll";
    repo = "hey";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fF3N/jDzpMFu6kXuHFDNaIjhFWJQWZAmZp5UTtMUmoU=";
  };

  vendorHash = "sha256-7lDArYNtCezHFijx1nr8+cF+10rLj67KuqjzdfCKXJ4=";

  meta = {
    description = "HTTP load generator, ApacheBench (ab) replacement";
    homepage = "https://github.com/rakyll/hey";
    license = lib.licenses.asl20;
    mainProgram = "hey";
  };
})

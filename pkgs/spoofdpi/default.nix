{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "SpoofDPI";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "xvzc";
    repo = "SpoofDPI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f3WwsHY4ZBYbot47uct1bx068gr9rqS+AsMHXcNhV2M=";
  };

  vendorHash = "sha256-EJBkjT/JqVap/vuL4yp3Jm+6lnHnnYtwmvi8uTvrZsE=";

  meta = {
    homepage = "https://github.com/xvzc/SpoofDPI";
    description = "Simple and fast anti-censorship tool written in Go";
    license = lib.licenses.asl20;
  };
})

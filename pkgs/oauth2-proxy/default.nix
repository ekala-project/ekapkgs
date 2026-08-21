{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module rec {
  pname = "oauth2-proxy";
  version = "7.15.3";

  src = fetchFromGitHub {
    repo = "oauth2-proxy";
    owner = "oauth2-proxy";
    sha256 = "sha256-HpWmIOqyE3L0JYAQh+bd30Gr2dDpTGH8DwFJo5XwflY=";
    rev = "v${version}";
  };

  vendorHash = "sha256-o4JWhqLbfHmlIY1XhaupIhYLfXJNguFueH+SpAe9xaw=";

  # Taken from https://github.com/oauth2-proxy/oauth2-proxy/blob/master/Makefile
  ldflags = [ "-X github.com/oauth2-proxy/oauth2-proxy/v7/pkg/version.VERSION=v${version}" ];
  meta = {
    description = "Reverse proxy that provides authentication with Google, GitHub, or other providers";
    homepage = "https://github.com/oauth2-proxy/oauth2-proxy/";
    license = lib.licenses.mit;
    mainProgram = "oauth2-proxy";
    maintainers = [ ];
  };
}

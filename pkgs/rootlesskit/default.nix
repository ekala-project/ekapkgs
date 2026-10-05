{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rootlesskit";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-L/0YW5mRSHgBQEA6R1bR21iKEEuy95IWdNN2SFLv6zo=";
  };

  vendorHash = "sha256-LbC8kAAF9nbkyzw+nmleaVuD8kEayDBCX4/i4UV21bQ=";
  meta = {
    homepage = "https://github.com/rootless-containers/rootlesskit";
    description = ''Kind of Linux-native "fake root" utility, made for mainly running Docker and Kubernetes as an unprivileged user'';
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})

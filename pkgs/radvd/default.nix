{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libbsd,
  libdaemon,
  bison,
  flex,
  check,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "radvd";
  version = "2.21";

  src = fetchFromGitHub {
    owner = "radvd-project";
    repo = "radvd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-02ZoLJ8nCk531M6DkP3UIPXgWyOOl2X163ou0ezHwKE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
    flex
    check
  ];

  buildInputs = [
    libdaemon
    libbsd
  ];

  # Needed for cross-compilation
  makeFlags = [ "AR=${stdenv.cc.targetPrefix}ar" ];

  meta = {
    homepage = "http://www.litech.org/radvd/";
    description = "IPv6 Router Advertisement Daemon";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsdOriginal;
  };
})

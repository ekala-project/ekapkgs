{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  flex,
  bison,
  readline,
  libssh,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bird";
  version = "2.19.3";

  src = fetchFromGitLab {
    domain = "gitlab.nic.cz";
    owner = "labs";
    repo = "bird";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rqkpYLt0PgC2BcQd6F/6N93kIdkxjP1cnhmmUzy6rnA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    flex
    bison
  ];

  buildInputs = [
    readline
    libssh
  ];

  patches = [
    ./dont-create-sysconfdir-2.patch
  ];

  env.CPP = "${stdenv.cc.targetPrefix}cpp -E";

  configureFlags = [
    "--localstatedir=/var"
    "--runstatedir=/run/bird"
  ];

  meta = {
    changelog = "https://gitlab.nic.cz/labs/bird/-/blob/v${finalAttrs.version}/NEWS";
    description = "BIRD Internet Routing Daemon";
    homepage = "https://bird.network.cz";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  libevent,
  pkg-config,
  libmicrohttpd,
  sqlite,
  systemdMinimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coturn";
  version = "4.16.0";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    tag = finalAttrs.version;
    hash = "sha256-XQeS81QImTQXeC60PKNPGAvlM39AsVLOGn+H72i9Kb8=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    (libevent.override { inherit openssl; })
    libmicrohttpd
    sqlite.dev
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform systemdMinimal) [
    systemdMinimal
  ];

  patches = [
    ./pure-configure.patch
  ];

  configureFlags = [
    "--examplesdir=.."
  ];

  env.NIX_CFLAGS_COMPILE = "-fcommon";

  meta = {
    description = "TURN server";
    homepage = "https://coturn.net/";
    changelog = "https://github.com/coturn/coturn/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})

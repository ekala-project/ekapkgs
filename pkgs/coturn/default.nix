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
  version = "4.19.2";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    tag = finalAttrs.version;
    hash = "sha256-C6/E/fl86vKBySd2ne5NJAst7OZf7lLx3J7PdzqQTrs=";
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
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  lua,
  jemalloc,
  pkg-config,
  tcl,
  which,
  ps,
  getconf ? null,
  withSystemd ? true,
  systemd,
  tlsSupport ? true,
  openssl,
  useSystemJemalloc ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "valkey";
  version = "9.1.2";

  src = fetchFromGitHub {
    owner = "valkey-io";
    repo = "valkey";
    rev = finalAttrs.version;
    hash = "sha256-Lq5AqrLKILnsaOdAgWeeukPNF7KerB17R1mUOZjOsUg=";
  };

  patches = lib.optional useSystemJemalloc ./use_system_jemalloc.patch;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    lua
  ]
  ++ lib.optional useSystemJemalloc jemalloc
  ++ lib.optional withSystemd systemd
  ++ lib.optional tlsSupport openssl;

  strictDeps = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "AR=${stdenv.cc.targetPrefix}ar"
    "RANLIB=${stdenv.cc.targetPrefix}ranlib"
  ]
  ++ lib.optionals withSystemd [ "USE_SYSTEMD=yes" ]
  ++ lib.optionals tlsSupport [ "BUILD_TLS=yes" ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isClang [ "-std=c11" ]);

  doCheck = false;

  meta = {
    homepage = "https://valkey.io/";
    description = "High-performance data structure server that primarily serves key/value workloads";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    changelog = "https://github.com/valkey-io/valkey/releases/tag/${finalAttrs.version}";
    mainProgram = "valkey-cli";
  };
})

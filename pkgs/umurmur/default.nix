{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  protobufc,
  libconfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "umurmur";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "umurmur";
    repo = "umurmur";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hxsWTqkbb/ZaLdi+z7EGQn3LXmmerHqNoRpn8Jrryjw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];
  buildInputs = [
    openssl
    protobufc
    libconfig
  ];

  passthru = {
    tests = {
    };
  };

  meta = {
    description = "Minimalistic Murmur (Mumble server)";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/umurmur/umurmur";
    platforms = lib.platforms.all;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
    mainProgram = "umurmurd";
  };
})

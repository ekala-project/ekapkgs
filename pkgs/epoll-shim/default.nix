{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "epoll-shim";
  version = "0.0.20240608";

  src = fetchFromGitHub {
    owner = "jiixyj";
    repo = "epoll-shim";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PIVzVjXOECGv41KtAUmGzUiQ+4lVIyzGEOzVQQ1Pc54=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeEntries = {
    CMAKE_INSTALL_PKGCONFIGDIR = "${placeholder ";
    BUILD_TESTING = "${lib.boolToString finalAttrs.finalPackage.doCheck}";
  };

  cmakeFlags = [
      out"}/lib/pkgconfig"
    ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform && stdenv.hostPlatform.isFreeBSD) [
    "-DALLOWS_ONESHOT_TIMERS_WITH_TIMEOUT_ZERO=YES"
  ];

  hardeningDisable = lib.optional stdenv.hostPlatform.isFreeBSD "fortify";

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Small epoll implementation using kqueue";
    homepage = "https://github.com/jiixyj/epoll-shim";
    license = lib.licenses.mit;
    platforms =
      lib.platforms.darwin ++ lib.platforms.freebsd ++ lib.platforms.netbsd ++ lib.platforms.openbsd;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  openssl,
  nghttp2,
  nlohmann_json,
  simdjson,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation {
  pname = "agentty";
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "1ay1";
    repo = "agentty";
    tag = "v0.9.11";
    hash = "sha256-2chfAJPzEKCqnX2YnyXrvhICeEF9+KUKp0jFN0xl8cc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake.configurePhaseHook
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    openssl
    nghttp2
    nlohmann_json
    simdjson
  ];

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
    (lib.cmakeBool "AGENTTY_USE_MIMALLOC" false)
    (lib.cmakeBool "MAYA_NATIVE_TUNING" false)
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 agentty $out/bin/agentty
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Terminal-native AI coding agent";
    homepage = "https://github.com/1ay1/agentty";
    changelog = "https://github.com/1ay1/agentty/releases/tag/v0.9.11";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "agentty";
    platforms = lib.platforms.unix;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "luau";
  version = "0.741";

  src = fetchFromGitHub {
    owner = "luau-lang";
    repo = "luau";
    tag = finalAttrs.version;
    hash = "sha256-/k9lU9PK+Wsexe1YtZRHrh089EaXx6W3ZbI1wMaVdsM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    python3
  ];

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.libunwind ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin luau
    install -Dm755 -t $out/bin luau-analyze
    install -Dm755 -t $out/bin luau-compile

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./Luau.UnitTest
    ./Luau.Conformance

    runHook postCheck
  '';
  meta = {
    description = "Fast, small, safe, gradually typed embeddable scripting language derived from Lua";
    homepage = "https://luau-lang.org/";
    changelog = "https://github.com/luau-lang/luau/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "luau";
  };
})

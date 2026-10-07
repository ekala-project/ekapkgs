{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "has";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "kdabir";
    repo = "has";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hms1FGlNTS9ENavPmfhFQrTkPj6Q95TYxCViHjAIMkg=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm0555 has -t $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/kdabir/has";
    description = "Checks presence of various command line tools and their versions on the path";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "has";
  };
})

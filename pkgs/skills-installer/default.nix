{
  lib,
  stdenv,
  fetchzip,
  nodejs,
}:

stdenv.mkDerivation rec {
  pname = "skills-installer";
  version = "0.3.1";

  src = fetchzip {
    url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
    hash = "sha256-YZmMRwT8A8rEQzn/geZbzq4gLmnTNED7H3eoaZeWdP4=";
  };

  buildInputs = [ nodejs ];

  installPhase = ''
    runHook preInstall
    install -Dm755 dist/cli.js $out/bin/skills-installer
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/skills-installer --help | grep -q "Install agent skills"
    runHook postInstallCheck
  '';

  meta = {
    description = "Install agent skills across multiple AI coding clients";
    homepage = "https://github.com/Kamalnrf/claude-plugins";
    changelog = "https://github.com/Kamalnrf/claude-plugins/releases";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "skills-installer";
    platforms = lib.platforms.all;
  };
}

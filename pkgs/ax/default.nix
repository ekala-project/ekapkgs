{
  lib,
  fetchFromGitHub,
  bun,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

bun.buildPackage {
  pname = "ax";
  version = "0.1.25";

  src = fetchFromGitHub {
    owner = "yusukebe";
    repo = "ax";
    tag = "v0.1.25";
    hash = "sha256-2F416Szv3Y5cHUB2yOKYKJeHDp7XChG11Lj/zIXsPKc=";
  };

  bunInstallFlags = [
    "--linker=isolated"
    "--backend=symlink"
    "--production"
  ];
  node_modulesHash = "sha256-/ux73JAcarBQWz3ofTIfJkH50RFHex+C6qO/4DkTGj8=";
  node_modulesAttrs.installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r node_modules $out/node_modules
    cp package.json $out/package.json
    runHook postInstall
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/ax $out/bin
    cp -r src package.json node_modules $out/share/ax/

    makeWrapper ${lib.getExe bun} $out/bin/ax \
      --add-flags "$out/share/ax/src/index.ts" \
      --set NODE_PATH "$out/share/ax/node_modules"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "The AI-era curl: fetch, discover, extract";
    homepage = "https://github.com/yusukebe/ax";
    changelog = "https://github.com/yusukebe/ax/releases/tag/v0.1.25";
    license = lib.licenses.mit;
    mainProgram = "ax";
    platforms = lib.platforms.unix;
  };
}

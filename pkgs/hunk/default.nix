{
  lib,
  fetchFromGitHub,
  bun,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

bun.buildPackage {
  pname = "hunk";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "modem-dev";
    repo = "hunk";
    tag = "v0.23.0";
    hash = "sha256-JQRNs0JG3v7lN1rFNikMyevAQjV0vfCCXjfPxmcKmqQ=";
  };

  node_modulesHash = "sha256-Eu71EvMbRac5fraJELQMnD8y++m4wKIzbG9LsSuRsAg=";
  node_modulesAttrs.postPatch = ''
    for f in package.json packages/*/package.json; do
      if [ -f "$f" ]; then
        sed -i 's/: "\^/: "/g; s/: "~/: "/g' "$f"
      fi
    done
    sed -i 's/: "\^/: "/g; s/: "~/: "/g' bun.lock
  '';

  bunBuildCommand = ''
    bun build --compile --no-compile-autoload-bunfig \
      ./packages/hunk/src/main.tsx \
      ./packages/hunk/src/highlightWorkerEntry.ts \
      --outfile hunk-bin
  '';

  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 ./hunk-bin $out/share/hunk/bin/hunk
    cp -r ./packages/hunk/skills $out/share/hunk/
    makeWrapper $out/share/hunk/bin/hunk $out/bin/hunk
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Terminal diff viewer for agentic changesets";
    homepage = "https://github.com/modem-dev/hunk";
    changelog = "https://github.com/modem-dev/hunk/releases/tag/v0.23.0";
    license = lib.licenses.mit;
    mainProgram = "hunk";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}

{
  lib,
  stdenvNoCC,
  fetchurl,
  bun,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "2.75.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@bitkyc08/opencodex/-/opencodex-${version}.tgz";
    hash = "sha256-uVX2tPxW9umDHUJcajiiRgO1ZH9bx18lKhhf6jUz6DA=";
  };
in
bun.buildPackage {
  pname = "opencodex";
  inherit version src;

  sourceRoot = "package";

  bunStdenv = stdenvNoCC;
  bunInstallFlags = [
    "--linker=isolated"
    "--backend=symlink"
    "--production"
  ];
  node_modulesHash = "sha256-ocGgJYx4d+FZlO8I1EunI1pY1pFIKGDManvLsBfhsLE=";
  node_modulesAttrs = {
    sourceRoot = "package";
    postUnpack = ''
      cp ${./bun.lock} "$sourceRoot/bun.lock"
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r node_modules $out/node_modules
      cp package.json $out/
      runHook postInstall
    '';
  };

  nativeBuildInputs = [ ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/opencodex $out/bin
    # Nix provides bun; drop the npm copy of the runtime and its dangling symlinks.
    rm -rf node_modules/.bun/bun@* node_modules/.bun/node_modules/bun \
      node_modules/bun node_modules/.bin/bun node_modules/.bin/bunx 2>/dev/null || true
    cp -r bin gui src package.json node_modules $out/lib/opencodex/

    makeWrapper ${lib.getExe bun} $out/bin/ocx \
      --add-flags "$out/lib/opencodex/src/cli/index.ts"
    ln -s ocx $out/bin/opencodex

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Universal provider proxy for OpenAI Codex, Claude Code, Claude Desktop & Grok Build";
    homepage = "https://github.com/lidge-jun/opencodex";
    changelog = "https://github.com/lidge-jun/opencodex/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "ocx";
    platforms = lib.platforms.all;
  };
}

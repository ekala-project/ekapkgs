{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeWrapper,
  nodejs,
  pnpm,
  pnpmConfigHook,
  stdenvNoCC,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  versionData = {
    version = "0.2.11";
    hash = "sha256-QsbJ3DW6fsGg9Tyre/bMh4WrHWfLdZdPQNfpHtx5u7g=";
    pnpmDepsHash = "sha256-231sRyDAntTejGhJbxCBnEHUHuVZFM5yYEkztDWKveE=";
    vendorHash = "sha256-9TK51JZvK+kW4IIrcdw1GANLndPBa+nrmB74GtPsYRU=";
  };
  inherit (versionData)
    version
    hash
    vendorHash
    pnpmDepsHash
    ;
in
buildGoModule (finalAttrs: {
  pname = "sub2api";
  inherit version;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Wei-Shaw";
    repo = "sub2api";
    tag = "v${finalAttrs.version}";
    inherit hash;
  };

  modRoot = "backend";
  subPackages = [ "cmd/server" ];
  inherit vendorHash;

  frontend = stdenvNoCC.mkDerivation (frontendAttrs: {
    pname = "sub2api-frontend";
    inherit (finalAttrs) version src;

    sourceRoot = "${frontendAttrs.src.name}/frontend";

    pnpmDeps = fetchPnpmDeps {
      inherit (frontendAttrs)
        pname
        version
        src
        sourceRoot
        ;
      pnpm = pnpm.v10;
      fetcherVersion = 3;
      hash = pnpmDepsHash;
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm.v10
    ];

    buildPhase = ''
      runHook preBuild
      chmod -R u+w node_modules 2>/dev/null || true
      patchShebangs node_modules 2>/dev/null || true
      for d in $PWD/node_modules/.bin; do export PATH="$d:$PATH"; done
      pnpm exec vue-tsc -b
      pnpm exec vite build --outDir "$TMPDIR/dist"
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r "$TMPDIR/dist" $out
      runHook postInstall
    '';
  });

  tags = [ "embed" ];
  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.BuildType=release"
  ];

  preBuild = ''
    cp -r ${finalAttrs.frontend} internal/web/dist
  '';

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mv $out/bin/server $out/bin/sub2api

    mkdir -p $out/share/sub2api
    cp -r resources $out/share/sub2api/

    wrapProgram $out/bin/sub2api \
      --set-default PRICING_FALLBACK_FILE \
        "$out/share/sub2api/resources/model-pricing/model_prices_and_context_window.json"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "AI API gateway platform for distributing and managing AI subscription API quotas";
    homepage = "https://github.com/Wei-Shaw/sub2api";
    changelog = "https://github.com/Wei-Shaw/sub2api/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "sub2api";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})

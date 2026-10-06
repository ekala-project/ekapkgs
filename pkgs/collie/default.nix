{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  bun,
  makeWrapper,
  jq,
  nodejs,
}:

let
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "AltanS";
    repo = "collie";
    tag = "v${version}";
    hash = "sha256-Ee4VEgoPSHtq4KWpL9tTMUik3GoMK50nVHG+VFHVY4U=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "collie-node_modules";
    inherit version src;

    nativeBuildInputs = [
      bun
      jq
    ];

    dontConfigure = true;

    postPatch = ''
      typesBun=$(sed -n 's/.*"@types\/bun@\([0-9][0-9.]*\)".*/\1/p' bun.lock | head -1)
      ${lib.getExe jq} --arg v "$typesBun" '.devDependencies."@types/bun" = $v' \
        package.json > package.json.tmp && mv package.json.tmp package.json
      sed -i 's/"@types\/bun": "latest"/"@types\/bun": "'"$typesBun"'"/' bun.lock
    '';

    buildPhase = ''
      runHook preBuild
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --frozen-lockfile --ignore-scripts --no-progress
      ( cd web && bun install --frozen-lockfile --ignore-scripts --no-progress )
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/repo
      runHook postInstall
    '';

    dontFixup = true;
    outputHash = "sha256-ZJpNcIIYWV0lrBtbYwlwFSbuP1T84OtSb2kUukJJdeo=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "collie";
  inherit version src;

  nativeBuildInputs = [
    bun
    makeWrapper
    jq
  ];

  dontConfigure = true;

  postPatch = ''
    typesBun=$(sed -n 's/.*"@types\/bun@\([0-9][0-9.]*\)".*/\1/p' bun.lock | head -1)
    ${lib.getExe jq} --arg v "$typesBun" '.devDependencies."@types/bun" = $v' \
      package.json > package.json.tmp && mv package.json.tmp package.json
    sed -i 's/"@types\/bun": "latest"/"@types\/bun": "'"$typesBun"'"/' bun.lock

    substituteInPlace web/vite.config.ts \
      --replace-fail 'const buildTime = new Date().toISOString();' \
        'const buildTime = new Date(Number(process.env.SOURCE_DATE_EPOCH ?? 0) * 1000).toISOString();'
  '';

  buildPhase = ''
    runHook preBuild

    cp -rf ${node_modules}/repo/. .
    chmod -R u+w .
    patchShebangs . || true
    grep -rIl '^#!/usr/bin/env ' node_modules web/node_modules 2>/dev/null | while IFS= read -r f; do
      case "$(head -1 "$f")" in
        *node*) sed -i "1s|.*|#!${lib.getExe nodejs}|" "$f" ;;
        *bash*) sed -i "1s|.*|#!${lib.getExe bash}|" "$f" ;;
      esac
    done

    pushd web
    bun run build
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    rm -rf node_modules/.bin node_modules/@types node_modules/typescript \
      node_modules/.bun/@types+*@* node_modules/.bun/typescript@* \
      node_modules/.bun/bun-types@*
    find node_modules -xtype l -delete

    mkdir -p $out/lib/collie
    cp -r bridge cli scripts systemd node_modules package.json herdr-plugin.toml \
      $out/lib/collie/
    mkdir -p $out/lib/collie/web
    cp -r web/dist $out/lib/collie/web/dist

    makeWrapper ${lib.getExe bun} $out/bin/collie \
      --add-flags "run $out/lib/collie/bridge/index.ts"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    test -f $out/lib/collie/web/dist/index.html
    test -f $out/lib/collie/web/dist/build-info.json
    runHook postInstallCheck
  '';

  meta = {
    description = "Mobile web UI to monitor and reply to your Herdr agent herd over Tailscale";
    homepage = "https://github.com/AltanS/collie";
    changelog = "https://github.com/AltanS/collie/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "collie";
    platforms = lib.platforms.unix;
  };
}

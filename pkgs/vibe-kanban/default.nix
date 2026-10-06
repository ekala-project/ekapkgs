{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  unzip,
  rustPlatform,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  pkg-config,
  openssl,
  libgit2,
  sqlite,
  llvmPackages,
  perl,
}:

let
  version = "0.1.44";
  tag = "v0.1.44-20260424091429";

  src = fetchFromGitHub {
    owner = "BloopAI";
    repo = "vibe-kanban";
    inherit tag;
    hash = "sha256-PNfk8spdjxg2TAaA6g83YJPugH2O5UirrjJIJ1GVoeo=";
  };

  releaseZip = fetchurl {
    url = "https://github.com/BloopAI/vibe-kanban/releases/download/${tag}/vibe-kanban-${tag}.zip";
    hash = "sha256-lMqN0w0EldusDHtuimAhogXBln9/GEmAFONT/IwYwqk=";
  };

  frontend = stdenv.mkDerivation {
    pname = "vibe-kanban-frontend";
    inherit version src;

    nativeBuildInputs = [
      nodejs
      pnpm.v10
      pnpmConfigHook
      unzip
    ];

    pnpmDeps = fetchPnpmDeps {
      pname = "vibe-kanban-frontend";
      inherit version src;
      pnpm = pnpm.v10;
      hash = "sha256-dOsbAKOb7O6MP04cfD7y7of0sDvNmEWovLTzjUnV+1Y=";
      fetcherVersion = 3;
    };

    buildPhase = ''
      runHook preBuild
      chmod -R u+w node_modules packages 2>/dev/null || true
      patchShebangs node_modules packages 2>/dev/null || true
      for d in $PWD/node_modules/.bin $PWD/packages/*/node_modules/.bin; do export PATH="$d:$PATH"; done

      export VITE_PUBLIC_REACT_VIRTUOSO_LICENSE_KEY=$(
        unzip -p ${releaseZip} '*/dist/assets/index-*.js' \
          | grep -o 'licenseKey:"[^"]*"' \
          | head -1 \
          | cut -d'"' -f2
      )

      pnpm --filter @vibe/local-web build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r packages/local-web/dist/* $out/
      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vibe-kanban";
  inherit version src;
  cargoHash = "sha256-P0sByQn9vK/Sm/ImiNCRtAJC6lG0M8ZqjxZFAJ4EiZ8=";

  cargoBuildFlags = [
    "--package"
    "server"
    "--package"
    "mcp"
    "--package"
    "review"
  ];

  nativeBuildInputs = [
    pkg-config
    llvmPackages.libclang
    perl
  ];

  buildInputs = [
    openssl
    libgit2
    sqlite
  ];

  preBuild = ''
    mkdir -p packages/local-web/dist
    cp -r ${frontend}/* packages/local-web/dist/
  '';

  env = {
    SQLX_OFFLINE = "true";
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  };

  doCheck = false;

  postInstall = ''
    mv $out/bin/server $out/bin/vibe-kanban
    mv $out/bin/review $out/bin/vibe-kanban-review
    rm -f $out/bin/generate_types
    rm -rf $out/bin/*.dSYM
  '';

  meta = {
    description = "Kanban board to orchestrate AI coding agents like Claude Code, Codex, and Gemini CLI";
    homepage = "https://github.com/BloopAI/vibe-kanban";
    changelog = "https://github.com/BloopAI/vibe-kanban/releases";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "vibe-kanban";
    platforms = lib.platforms.unix;
  };
})

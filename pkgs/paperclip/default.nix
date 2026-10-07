{
  lib,
  fetchzip,
  importNpmLock,
  nodejs,
  postgresql,
  python3,
  stdenv,
  runCommand,
}:

let
  version = "2026.916.1";

  src = runCommand "paperclipai-${version}-src" { } ''
    mkdir -p $out
    cp -r ${
      fetchzip {
        url = "https://registry.npmjs.org/paperclipai/-/paperclipai-${version}.tgz";
        hash = "sha256-D3IIGbeK2RayQH/YtUFCV7dpnqMD0/zChXzkwdQIhFo=";
      }
    }/. $out/
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
nodejs.buildNpmApplication {
  pname = "paperclip";
  npmPackName = "paperclipai";
  inherit version src;
  npmDeps = importNpmLock { npmRoot = ./.; };

  # The npm tarball is already built.
  dontNpmBuild = true;

  nativeBuildInputs = [ python3 ];
  # buildNpmApplication drops npmRebuildFlags before the derivation env, so
  # inject it explicitly for importNpmLock's npmConfigHook.
  env.npmRebuildFlagsArray = "--ignore-scripts";
  env.npmInstallFlagsArray = "--ignore-scripts";
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  postInstall = ''
    embedded=$(find $out/lib/node_modules -path '*/embedded-postgres/dist/binary.js' -print -quit)
    test -n "$embedded"
    cat > "$embedded" <<'EOF'
    function getBinaries() {
      return Promise.resolve({
        postgres: "${postgresql}/bin/postgres",
        initdb: "${postgresql}/bin/initdb",
        pg_ctl: "${postgresql}/bin/pg_ctl",
      });
    }
    export default getBinaries;
    EOF

    # nixpkgs PostgreSQL defaults its unix socket to /run/postgresql, which
    # unprivileged users cannot write to. Keep the socket in the data dir.
    substituteInPlace "$(dirname "$embedded")/index.js" \
      --replace-fail "...this.options.postgresFlags," \
        "'-k', this.options.databaseDir, ...this.options.postgresFlags,"

    # Drop the now unused FHS-linked binaries.
    while IFS= read -r scope; do
      find "$scope" -mindepth 1 -maxdepth 1 ! -name symlink-reader -exec rm -rf {} +
    done < <(find $out/lib/node_modules -path '*/node_modules/@embedded-postgres' -type d)
  '';

  meta = {
    description = "Open-source control plane for managing teams of AI agents";
    homepage = "https://paperclip.ing";
    changelog = "https://github.com/paperclipai/paperclip/releases/tag/v${version}";
    downloadPage = "https://www.npmjs.com/package/paperclipai";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "paperclipai";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}

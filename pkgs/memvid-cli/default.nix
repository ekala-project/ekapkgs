{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  openssl,
  zlib,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "memvid-cli";
  version = "2.0.160";

  src = fetchzip {
    url = "https://registry.npmjs.org/@memvid/cli-linux-x64/-/cli-linux-x64-${finalAttrs.version}.tgz";
    hash = "sha256-we0KZzKrYRATJElP9OkR4hERQ5S+Zb9qFDCO3WJtV/I=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    libx11
    libxext
    libxi
    libxrender
    libxtst
    openssl
    stdenv.cc.cc.lib
    zlib
  ];

  installPhase = ''
    runHook preInstall

    install -d $out/libexec/memvid-cli
    cp -R $src/. $out/libexec/memvid-cli/
    chmod -R u+w $out/libexec/memvid-cli
    chmod 755 $out/libexec/memvid-cli/memvid

    makeWrapper $out/libexec/memvid-cli/memvid $out/bin/memvid \
      --prefix LD_LIBRARY_PATH : "$out/libexec/memvid-cli"

    runHook postInstall
  '';

  doInstallCheck = true;

  # --version prints the bundled memvid-core version, not the npm package
  # version, so just smoke-test --help.
  installCheckPhase = ''
    runHook preInstallCheck
    tmp_home=$(mktemp -d)
    tmp_cache=$(mktemp -d)
    HOME="$tmp_home" XDG_CACHE_HOME="$tmp_cache" $out/bin/memvid --help > /dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "AI memory CLI: crash-safe, single-file storage with semantic search";
    homepage = "https://memvid.com";
    changelog = "https://github.com/memvid/memvid/releases";
    license = lib.licenses.asl20;
    # CLI is closed-source; the upstream repo only contains the memvid-core library.
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "memvid";
    platforms = [ "x86_64-linux" ];
  };
})

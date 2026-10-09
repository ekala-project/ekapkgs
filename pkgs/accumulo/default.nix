{
  lib,
  stdenv,
  fetchurl,
  java,
  makeWrapper,
  bash,
  coreutils,
}:

let
  # Accumulo 2.1 supports Java 11 and 17.
  jre = java.v11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "accumulo";
  version = "2.1.3";

  src = fetchurl {
    url = "https://archive.apache.org/dist/accumulo/${finalAttrs.version}/accumulo-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-mNZp8BnKu/kOqtXSf1Fo2OxPw27+I6XS/eKGE5vZDBE=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R bin conf lib $out
    cp LICENSE NOTICE README.md $out
    patchShebangs $out/bin
    for i in $out/bin/accumulo $out/bin/accumulo-cluster $out/bin/accumulo-service $out/bin/accumulo-util; do
      wrapProgram $i \
        --set JAVA_HOME "${jre}" \
        --prefix PATH : "${
          lib.makeBinPath [
            bash
            coreutils
          ]
        }"
    done
    runHook postInstall
  '';

  passthru = {
    inherit jre;
  };

  meta = {
    homepage = "https://accumulo.apache.org";
    description = "Sorted, distributed key/value store based on Google's BigTable design";
    changelog = "https://github.com/apache/accumulo/blob/rel/2.1.3/CHANGES.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    mainProgram = "accumulo";
  };
})

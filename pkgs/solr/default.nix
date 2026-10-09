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
  # Solr 9.x supports Java 11+ (17 recommended).
  jre = java.v17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "solr";
  version = "9.9.0";

  src = fetchurl {
    url = "https://archive.apache.org/dist/solr/solr/${finalAttrs.version}/solr-${finalAttrs.version}.tgz";
    hash = "sha256-60qIhZOljIQV7ZWRSN1wrnN5oUGZGV+bs3Q6W7EKkWk=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R bin lib modules server docs licenses example $out
    cp CHANGES.txt LICENSE.txt NOTICE.txt README.txt $out
    patchShebangs $out/bin
    wrapProgram $out/bin/solr \
      --set JAVA_HOME "${jre}" \
      --prefix PATH : "${
        lib.makeBinPath [
          bash
          coreutils
        ]
      }"
    wrapProgram $out/bin/post \
      --set JAVA_HOME "${jre}" \
      --prefix PATH : "${
        lib.makeBinPath [
          bash
          coreutils
        ]
      }"
    runHook postInstall
  '';

  passthru = {
    inherit jre;
  };

  meta = {
    homepage = "https://solr.apache.org";
    description = "Enterprise search platform built on Apache Lucene";
    changelog = "https://solr.apache.org/docs/${lib.versions.majorMinor finalAttrs.version}.0/changes.html";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    mainProgram = "solr";
  };
})

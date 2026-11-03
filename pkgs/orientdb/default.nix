{
  lib,
  maven,
  fetchFromGitHub,
  java,
  makeWrapper,
  bash,
  coreutils,
}:

maven.buildMavenPackage (finalAttrs: {
  pname = "orientdb-community";
  version = "3.2.57";

  src = fetchFromGitHub {
    owner = "orientechnologies";
    repo = "orientdb";
    rev = finalAttrs.version;
    hash = "sha256-HVUcjsUYZHmA3+2PPm2tY6XoUUecahG9X6TCO7QBt3M=";
  };

  mvnHash = "sha256-nEdY9S1UL0Iwrx5VwNfmMnTa8PUS66FrDbA5aosxYMs=";

  # Tests require fontconfig/X11 which are unavailable in the sandbox
  mvnParameters = "-DskipTests -Dmaven.test.skip=true";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ java ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R distribution/target/orientdb-community-${finalAttrs.version}.dir/orientdb-community-${finalAttrs.version}/. $out/
    rm -rf $out/log $out/databases
    patchShebangs $out/bin
    for i in $out/bin/*.sh; do
      wrapProgram "$i" \
        --set JAVA_HOME "${java}" \
        --prefix PATH : "${
          lib.makeBinPath [
            bash
            coreutils
          ]
        }"
    done
    runHook postInstall
  '';

  meta = {
    description = "Multi-model database that supports graph, document, key/value and object models";
    homepage = "https://orientdb.org";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "server.sh";
  };
})

{
  lib,
  maven,
  fetchFromGitHub,
  protobuf,
  java,
  makeWrapper,
  bash,
  coreutils,
  stdenv,
}:

let
  runtimePath = lib.makeBinPath [
    bash
    coreutils
  ];
in
maven.buildMavenPackage (finalAttrs: {
  pname = "hugegraph-server";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "incubator-hugegraph";
    rev = finalAttrs.version;
    hash = "sha256-ooQ44B03dJMbp6vIhDeL9qJ2UbczXOgKoXqGm5cnKOU=";
  };

  # hugegraph-core generates Java from raft.proto with the protobuf-maven-plugin.
  # Point it at the Nix-provided protoc instead of the binary it would download
  # (the downloaded one has a non-relocatable ELF interpreter and will not run
  # in the sandbox).
  postPatch = ''
    substituteInPlace hugegraph-server/hugegraph-core/pom.xml \
      --replace-fail '<protocArtifact>' '<!--' \
      --replace-fail '</protocArtifact>' '-->' \
      --replace-fail '<pluginId>protoc-java</pluginId>' '<protocExecutable>${lib.getExe protobuf.v21}</protocExecutable>'

    # sjk-core pulls in profiling parsers whose POMs declare non-absolute
    # systemPaths, which Maven 3.9 rejects; hugegraph-api only uses sjk-core's
    # AntPathMatcher, so drop the parsers.
    sed -i '/<artifactId>sjk-core<\/artifactId>/,/<\/dependency>/ {
      /<\/dependency>/ i\
        <exclusions>\
          <exclusion>\
            <groupId>org.perfkit.sjk.parsers</groupId>\
            <artifactId>sjk-jfr5</artifactId>\
          </exclusion>\
          <exclusion>\
            <groupId>org.perfkit.sjk.parsers</groupId>\
            <artifactId>sjk-jfr6</artifactId>\
          </exclusion>\
        </exclusions>
    }' hugegraph-server/hugegraph-api/pom.xml
  '';

  buildOffline = true;
  mvnHash = "sha256-DH8zPxqWqmO9WZDuvHjdWoInKXMgbrfS+epvPJihwgM=";
  mvnJdk = java.v11;
  mvnParameters = "-DskipTests -Dmaven.javadoc.skip=true -Drat.skip=true";
  manualMvnArtifacts = [ "org.apache:apache-jar-resource-bundle:1.4" ];
  doCheck = false;

  # Several transitive POMs (sjk-nps, sjk-jfr5) declare `system`-scope deps with
  # non-absolute ${...} systemPaths, which Maven 3.9 rejects. They are optional
  # profiling dependencies; downgrade them to `provided` and drop the paths.
  afterDepsSetup = ''
    while IFS= read -r pom; do
      sed -i \
        -e 's|<scope>system</scope>|<scope>provided</scope>|' \
        -e '/<systemPath>/d' \
        "$pom"
    done < <(grep -rl '<systemPath>' .m2 || true)

    # grpc-netty-shaded declares grpc-core with the range [1.47.0]; the
    # remote-resources plugin cannot resolve ranges offline. Pin it.
    while IFS= read -r pom; do
      sed -i 's|<version>\[1.47.0\]</version>|<version>1.47.0</version>|g' "$pom"
    done < <(grep -rl '<version>\[1.47.0\]</version>' .m2 || true)
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ java.v11 ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R hugegraph-server/apache-hugegraph-incubating-${finalAttrs.version}/. $out/
    for i in start-hugegraph.sh stop-hugegraph.sh hugegraph-server.sh init-store.sh; do
      wrapProgram "$out/bin/$i" \
        --set JAVA_HOME "${java.v11}" \
        --prefix PATH : "${runtimePath}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
      substituteInPlace "$out/bin/.$i-wrapped" \
        --replace-fail '#!/bin/bash' '#!${bash}/bin/bash'
    done
    patchShebangs $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Highly scalable graph database optimized for storing and querying massive graphs";
    homepage = "https://hugegraph.apache.org";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "start-hugegraph.sh";
  };
})

{
  lib,
  stdenv,
  fetchurl,
  java,
  makeWrapper,
  bash,
  coreutils,
  grep,
  sed,
  ps,
}:

let
  versionInfo = {
    kafkaVersion = "4.1.1";
    scalaVersion = "2.13";
    sha256 = "sha256-eR6O5plpgtgFWCk2eoA5H5TBvKcymy+7ZYv8IRp3Ry4=";
    jre = java.v17;
  };
  version = "${versionInfo.scalaVersion}-${versionInfo.kafkaVersion}";
in
stdenv.mkDerivation rec {
  pname = "apache-kafka";
  inherit version;

  src = fetchurl {
    url = "mirror://apache/kafka/${versionInfo.kafkaVersion}/kafka_${version}.tgz";
    inherit (versionInfo) sha256;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    versionInfo.jre
    bash
    grep
    sed
    coreutils
    ps
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R config libs $out

    mkdir -p $out/bin
    cp bin/kafka* $out/bin
    cp bin/connect* $out/bin

    # allow us the specify logging directory using env
    substituteInPlace $out/bin/kafka-run-class.sh \
      --replace-fail 'LOG_DIR="$base_dir/logs"' 'LOG_DIR="$KAFKA_LOG_DIR"'

    substituteInPlace $out/bin/kafka-server-stop.sh \
      --replace-fail 'ps' '${ps}/bin/ps'

    for p in $out/bin/*.sh; do
      wrapProgram $p \
        --set JAVA_HOME "${versionInfo.jre}" \
        --set KAFKA_LOG_DIR "/tmp/apache-kafka-logs" \
        --prefix PATH : "${
          lib.makeBinPath [
            bash
            coreutils
            grep
            sed
          ]
        }"
    done
    chmod +x $out/bin/*
    runHook postInstall
  '';

  passthru.jre = versionInfo.jre;

  meta = {
    homepage = "https://kafka.apache.org";
    description = "High-throughput distributed messaging system";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    platforms = lib.platforms.unix;
    mainProgram = "kafka-server-start.sh";
  };
}

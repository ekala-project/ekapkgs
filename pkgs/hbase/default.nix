{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  java,
}:

stdenv.mkDerivation rec {
  pname = "hbase";
  version = "2.6.2";

  src = fetchurl {
    url = "mirror://apache/hbase/${version}/hbase-${version}-bin.tar.gz";
    hash = "sha256-X/mjmTAx9anh2U/Xlfuf+O4AO5BXDkdsY69tPddEpYM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R * $out
    wrapProgram $out/bin/hbase --set-default JAVA_HOME ${java.v11} \
      --run "test -d /etc/hadoop-conf && export HBASE_CONF_DIR=\''${HBASE_CONF_DIR-'/etc/hadoop-conf/'}" \
      --set-default HBASE_LOG_DIR "/tmp/hbase-logs" \
      --set-default HBASE_CONF_DIR "$out/conf/"
    runHook postInstall
  '';

  meta = {
    description = "Distributed, scalable, big data store";
    homepage = "https://hbase.apache.org";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "hbase";
  };
}

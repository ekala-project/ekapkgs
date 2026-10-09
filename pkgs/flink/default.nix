{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  java,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flink";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://apache/flink/${finalAttrs.pname}-${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}-bin-scala_2.12.tgz";
    sha256 = "sha256-B/EhLtDKve1SKoayDy6E64Lk4FTln3FL79kh3CcHLEU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ java.v21 ];

  installPhase = ''
    runHook preInstall

    rm bin/*.bat || true

    mkdir -p $out/bin $out/opt/flink
    mv * $out/opt/flink/
    makeWrapper $out/opt/flink/bin/flink $out/bin/flink \
      --prefix PATH : ${java.v21}/bin

    cat <<EOF >> $out/opt/flink/conf/flink-conf.yaml
    env.java.home: ${java.v21}
    env.log.dir: /tmp/flink-logs
    EOF

    runHook postInstall
  '';

  meta = {
    description = "Distributed stream processing framework";
    mainProgram = "flink";
    homepage = "https://flink.apache.org";
    downloadPage = "https://flink.apache.org/downloads.html";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = lib.platforms.all;
  };
})

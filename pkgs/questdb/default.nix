{
  fetchurl,
  java,
  lib,
  makeBinaryWrapper,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "questdb";
  version = "9.3.2";

  src = fetchurl {
    url = "https://github.com/questdb/questdb/releases/download/${finalAttrs.version}/questdb-${finalAttrs.version}-no-jre-bin.tar.gz";
    hash = "sha256-64ffNDBbaPoKGOeidCnqXT8NkWIq+UAOrfRkh8sSQp4=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/java
    cp questdb.sh $out/bin
    cp env.sh $out/bin
    cp print-hello.sh $out/bin
    cp questdb.jar $out/share/java

    ln -s $out/share/java/questdb.jar $out/bin
    wrapProgram $out/bin/questdb.sh --set JAVA_HOME "${java.v17}"

    runHook postInstall
  '';

  meta = {
    description = "High-performance, open-source SQL database for applications in financial services, IoT, machine learning, DevOps and observability";
    homepage = "https://questdb.io/";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "questdb.sh";
  };
})

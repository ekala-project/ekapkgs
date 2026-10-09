{
  lib,
  stdenv,
  fetchurl,
  mysql_jdbc,
  mysqlSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apache-druid";
  version = "34.0.0";

  src = fetchurl {
    url = "mirror://apache/druid/${finalAttrs.version}/apache-druid-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-y5Sx8mubb+XEqPxlhPL67od1kVck2M+IkvQP/CyrZpA=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv * $out
    ${lib.optionalString mysqlSupport "ln -s ${mysql_jdbc}/share/java/mysql-connector-j.jar $out/extensions/mysql-metadata-storage"}
    runHook postInstall
  '';

  meta = {
    description = "Apache Druid: a high performance real-time analytics database";
    homepage = "https://github.com/apache/druid";
    license = lib.licenses.asl20;
    mainProgram = "druid";
  };
})

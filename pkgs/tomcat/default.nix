{
  lib,
  stdenvNoCC,
  fetchurl,
  jdk,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "apache-tomcat";
  version = "11.0.7";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-${lib.versions.major finalAttrs.version}/v${finalAttrs.version}/bin/apache-tomcat-${finalAttrs.version}.tar.gz";
    hash = "sha256-L87OZBxiuh8o4deyV0kxUfxE8WH7ORAV7mqV+nFjL7k=";
  };

  outputs = [
    "out"
    "webapps"
  ];

  installPhase = ''
    mkdir $out
    mv * $out
    mkdir -p $webapps/webapps
    mv $out/webapps $webapps/
  '';

  meta = {
    homepage = "https://tomcat.apache.org/";
    description = "Implementation of the Java Servlet and JavaServer Pages technologies";
    platforms = jdk.meta.platforms;
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})

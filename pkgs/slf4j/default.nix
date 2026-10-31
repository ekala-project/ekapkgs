{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "2.0.20";
in
stdenv.mkDerivation {
  pname = "slf4j";
  inherit version;

  srcs = [
    (fetchurl {
      url = "https://repo1.maven.org/maven2/org/slf4j/slf4j-api/${version}/slf4j-api-${version}.jar";
      hash = "sha256-fhRGSZs1lnXYqr5q8t6GuF5yrooqkywLQNDlulcJdDk=";
    })
    (fetchurl {
      url = "https://repo1.maven.org/maven2/org/slf4j/slf4j-simple/${version}/slf4j-simple-${version}.jar";
      hash = "sha256-jnAUBHhqT4chnTnUhTyG3+ToaumTdqOXSd9sCOdQIuA=";
    })
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/java
    for src in $srcs; do
      cp "$src" "$out/share/java/$(stripHash "$src")"
    done
    runHook postInstall
  '';

  meta = {
    description = "Simple Logging Facade for Java";
    homepage = "https://www.slf4j.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}

{
  lib,
  stdenv,
  fetchurl,
  erlang,
  icu,
  openssl,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "couchdb";
  version = "3.5.0";

  src = fetchurl {
    url = "mirror://apache/couchdb/source/${version}/apache-${pname}-${version}.tar.gz";
    hash = "sha256-api5CpqYC77yw1tJlqjnGi8a5SJ1RshfBMQ2EBvfeL8=";
  };

  postPatch = ''
    patchShebangs bin/rebar
  '';

  nativeBuildInputs = [ erlang ];

  buildInputs = [
    icu
    openssl
    (python3.withPackages (ps: with ps; [ requests ]))
  ];

  dontAddPrefix = "True";

  configureFlags = [
    "--js-engine=quickjs"
    "--disable-spidermonkey"
  ];

  buildFlags = [ "release" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r rel/couchdb/* $out
    runHook postInstall
  '';

  meta = {
    description = "Database that uses JSON for documents, JavaScript for MapReduce queries, and regular HTTP for an API";
    homepage = "https://couchdb.apache.org";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}

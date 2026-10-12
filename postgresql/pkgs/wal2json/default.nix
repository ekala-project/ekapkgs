{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "wal2json";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "eulerto";
    repo = "wal2json";
    tag = "wal2json_${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-+QoACPCKiFfuT2lJfSUmgfzC5MXf75KpSoc2PzPxKyM=";
  };

  makeFlags = [ "USE_PGXS=1" ];

  meta = {
    description = "JSON output plugin for changeset extraction (logical decoding)";
    homepage = "https://github.com/eulerto/wal2json";
    license = lib.licenses.bsd3;
    platforms = postgresql.meta.platforms;
  };
})

{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_repack";
  version = "1.5.3";

  buildInputs = postgresql.buildInputs;

  src = fetchFromGitHub {
    owner = "reorg";
    repo = "pg_repack";
    tag = "ver_${finalAttrs.version}";
    hash = "sha256-Ufh/dKrKumRKeQ/CpwvxbjAmgILAn04BduPZMRvS+nU=";
  };

  meta = {
    description = "Reorganize tables in PostgreSQL databases with minimal locks";
    longDescription = ''
      pg_repack is a PostgreSQL extension which lets you remove bloat from tables
      and indexes, and optionally restore the physical order of clustered indexes.
      Unlike CLUSTER and VACUUM FULL it works online, without holding an exclusive
      lock on the processed tables during processing.
    '';
    homepage = "https://reorg.github.io/pg_repack/";
    changelog = "https://github.com/reorg/pg_repack/releases/tag/ver_${finalAttrs.version}";
    platforms = postgresql.meta.platforms;
    license = lib.licenses.bsd3;
  };
})

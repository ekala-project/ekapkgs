{
  curl,
  fetchFromGitHub,
  fetchpatch,
  lib,
  lz4,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "citus";
  version = "13.0.3";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "citus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tQ2YkMUeziz+dhfXtfuK0x8PWH3vfoJiVbE+YvQ/Gzc=";
  };

  patches = [
    # Fixes build for PG 16 + 17 on darwin; on main since Sep 2023 but not yet
    # in the release-13.0 branch.
    (fetchpatch {
      url = "https://github.com/citusdata/citus/commit/0f28a69f12418d211ffba5f7ddd222fd0c47daeb.patch";
      hash = "sha256-8JAM+PUswzbdlAZUpRApgO0eBsMbUHFdFGsdATsG88I=";
    })
  ];

  buildInputs = [
    curl
    lz4
  ];

  meta = {
    description = "Distributed database built on PostgreSQL";
    homepage = "https://www.citusdata.com/";
    changelog = "https://github.com/citusdata/citus/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    platforms = postgresql.meta.platforms;
  };
})

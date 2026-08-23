{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {

  pname = "bkt";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "dimo414";
    repo = "bkt";
    tag = finalAttrs.version;
    sha256 = "sha256-qb7uRvCAXCayDIg8yQfF/Yxe0pNvR3giCQYmMIur2rM=";
  };

  cargoHash = "sha256-locf3k0jIT9RNQS9yCUtOpj4oKo5pOBU3CEYAJDbaPU=";

  checkFlags = [
    # tries to run external commands not available in the sandbox
    "--skip=cli::cache_dirs_multi_user"
  ];

  meta = {
    description = "Subprocess caching utility";
    homepage = "https://github.com/dimo414/bkt";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "bkt";
  };
})

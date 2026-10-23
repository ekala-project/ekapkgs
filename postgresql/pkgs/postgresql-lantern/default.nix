{
  cmake,
  fetchFromGitHub,
  lib,
  openssl,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "postgresql-lantern";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lanterndata";
    repo = "lantern";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IsDD/um5pVvbzin8onf45DQVszl+Id/pJSQ2iijgHmg=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace lantern_hnsw/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.3)" "cmake_minimum_required(VERSION 3.10)"

    patchShebangs --build lantern_hnsw/scripts/link_llvm_objects.sh
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [ openssl ];

  cmakeEntries = {
    BUILD_FOR_DISTRIBUTING = true;
  };

  # -S is a non -D flag (source directory), so it stays in cmakeFlags.
  cmakeFlags = [ "-S ../lantern_hnsw" ];

  meta = {
    description = "PostgreSQL vector database extension for building AI applications";
    homepage = "https://lantern.dev/";
    changelog = "https://github.com/lanterndata/lantern/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsl11;
    platforms = postgresql.meta.platforms;
  };
})

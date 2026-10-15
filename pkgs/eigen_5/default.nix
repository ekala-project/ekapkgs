{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  cmake,
  doxygen,
  graphviz,
  withDoc ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eigen";
  version = "5.0.1";

  src = fetchFromGitLab {
    owner = "libeigen";
    repo = "eigen";
    tag = finalAttrs.version;
    hash = "sha256-8TW1MUXt2gWJmu5YbUWhdvzNBiJ/KIVwIRf2XuVZeqo=";
  };

  patches = [
    # merged upstream
    (fetchpatch {
      name = "fix-doc.patch";
      url = "https://gitlab.com/libeigen/eigen/-/commit/976f15ebca3f486902c3da4c98b8f92c3c4ed7a4.diff";
      hash = "sha256-/FSXhY+/ZRKfE/aIDAgP+DoNCtH8ikUItYGmfo+QH0E=";
    })
  ];

  outputs = [
    "out"
  ]
  ++ lib.optional withDoc "doc";

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ]
  ++ lib.optionals withDoc [
    doxygen
    graphviz
  ];

  cmakeEntries = {
    EIGEN_BUILD_DOC = withDoc;
  };

  postInstall = lib.optionalString withDoc ''
    # Fontconfig error: No writable cache directories
    export XDG_CACHE_HOME="$(mktemp -d)"

    cmake --build . -t install-doc
  '';

  # tests are super long and mostly flaky
  doCheck = false;

  meta = {
    homepage = "https://eigen.tuxfamily.org";
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    changelog = "https://gitlab.com/libeigen/eigen/-/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
  };
})

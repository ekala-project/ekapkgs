{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  gmp,
  mpfr,
  libedit,
  installShellFiles,
  texinfo,
  gnused,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ledger";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "ledger";
    repo = "ledger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yk6/4ImUzgZY8O7MmQMwFkuJ/pMXo6W5TAA0GGIxYgg=";
  };

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [
    gmp
    mpfr
    libedit
    gnused
    boost
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    texinfo
    installShellFiles
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeBool "BUILD_DOCS" true)
    (lib.cmakeBool "USE_PYTHON" false)
    (lib.cmakeBool "USE_GPGME" false)
  ];

  installTargets = [
    "doc"
    "install"
  ];

  postInstall = ''
    installShellCompletion --cmd ledger --bash $src/contrib/ledger-completion.bash
  '';

  meta = {
    description = "Double-entry accounting system with a command-line reporting interface";
    mainProgram = "ledger";
    homepage = "https://www.ledger-cli.org/";
    changelog = "https://github.com/ledger/ledger/raw/v${finalAttrs.version}/NEWS.md";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})

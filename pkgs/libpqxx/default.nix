{
  lib,
  stdenv,
  fetchFromGitHub,
  libpq,
  python3,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpqxx";
  version = "7.10.7";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = "libpqxx";
    rev = finalAttrs.version;
    hash = "sha256-A33Z6xSIReYHHS3KerBSDTuo59tixduxXVEMfa/2I7A=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    python3
  ];

  buildInputs = [
    libpq
  ];

  postPatch = ''
    # Disable linting step for tests, it tries to install packages with pip.
    substituteInPlace Makefile.am \
      --replace-fail "TESTS = tools/lint" ""

    patchShebangs ./tools/splitconfig.py
    patchShebangs tools/*.py
  '';

  configureFlags = [
    "--disable-documentation"
    "--enable-shared"
  ];

  doCheck = false;

  enableParallelBuilding = true;

  strictDeps = true;

  meta = {
    changelog = "https://github.com/jtv/libpqxx/releases/tag/${finalAttrs.version}";
    description = "C++ library to access PostgreSQL databases";
    homepage = "https://pqxx.org/development/libpqxx/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})

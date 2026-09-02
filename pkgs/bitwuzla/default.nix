{
  stdenv,
  fetchFromGitHub,
  lib,
  python3,
  meson,
  ninja,
  btor2tools ? null,
  symfpu ? null,
  gtest ? null,
  gmpxx,
  cadical,
  cadical' ? cadical,
  cryptominisat ? null,
  kissat ? null,
  zlib,
  pkg-config,
  cmake,
  aiger ? null,
  mpfr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bitwuzla";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "bitwuzla";
    repo = "bitwuzla";
    tag = finalAttrs.version;
    hash = "sha256-3uStLdDFhXVgqzremUPRbxPUcl0IqVg5MRLltgm8rCA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    cmake
  ];

  buildInputs = [
    cadical'
    gmpxx
    zlib
    mpfr
  ]
  ++ lib.optional (cryptominisat != null) cryptominisat
  ++ lib.optional (btor2tools != null) btor2tools
  ++ lib.optional (symfpu != null) symfpu
  ++ lib.optional (kissat != null) kissat
  ++ lib.optional (aiger != null) aiger;

  mesonFlags = [
    "-Ddefault_library=shared"
    (lib.strings.mesonEnable "testing" finalAttrs.finalPackage.doCheck)
  ]
  ++ lib.optional (cryptominisat != null) "-Dcryptominisat=true"
  ++ lib.optional (kissat != null) "-Dkissat=true"
  ++ lib.optional (aiger != null) "-Daiger=true";

  nativeCheckInputs = [ python3 ];
  checkInputs = lib.optional (gtest != null) gtest;
  doCheck = stdenv.hostPlatform.isLinux;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export needle=11011110101011011011111011101111

    cat > file.smt2 <<EOF
    (declare-fun a () (_ BitVec 32))
    (assert (= a #b$needle))
    (check-sat)
    (get-model)
    EOF

    (
    set -euxo pipefail;
    $out/bin/bitwuzla -S cadical -m file.smt2 | tee /dev/stderr | grep $needle;
    )

    runHook postInstallCheck
  '';

  meta = {
    description = "SMT solver for fixed-size bit-vectors, floating-point arithmetic, arrays, and uninterpreted functions";
    mainProgram = "bitwuzla";
    homepage = "https://bitwuzla.github.io";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

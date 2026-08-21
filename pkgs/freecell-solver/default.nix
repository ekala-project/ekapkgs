{
  lib,
  stdenv,
  fetchurl,
  cmake,
  cmocka,
  gmp,
  gperf,
  ninja,
  perl,
  pkg-config,
  python3,
  rinutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freecell-solver";
  version = "6.16.0";

  src = fetchurl {
    url = "https://fc-solve.shlomifish.org/downloads/fc-solve/freecell-solver-${finalAttrs.version}.tar.xz";
    hash = "sha256-cbiILmjxvmJSkGkBjQxzK3UHhmkHfJY0gnlXWEnzQxM=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  pythonPath = with python3.pkgs; [
    cffi
    random2
    six
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    cmocka
    gperf
    ninja
    perl
    pkg-config
    python3
  ]
  ++ (
    with perl.pkgs;
    TaskFreecellSolverTesting.buildInputs
    ++ [
      GamesSolitaireVerify
      HTMLTemplate
      Moo
      PathTiny
      StringShellQuote
      TaskFreecellSolverTesting
      TemplateToolkit
      TextTemplate
    ]
  )
  ++ [ python3.pkgs.wrapPython ]
  ++ finalAttrs.pythonPath;

  buildInputs = [
    gmp
    rinutils
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "FCS_WITH_TEST_SUITE" false)
    (lib.cmakeBool "BUILD_STATIC_LIBRARY" false)
  ];

  postPatch = ''
    # Remove assertion for pysol_cards which is not available
    substituteInPlace CMakeLists.txt \
      --replace-fail 'ASSERT_PYTHON3_MODULE_PRESENCE("pysol_cards" "")' "" \
      --replace-fail 'ASSERT_PYTHON3_MODULE_PRESENCE("pysol_cards.gen_multi_cli" "")' ""
  '';

  preFixup = ''
    # This is a module and should not be wrapped, or it causes import errors
    chmod a-x $out/bin/fc_solve_find_index_s2ints.py
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/bin" "$out ''${pythonPath[*]}"
  '';

  doInstallCheck = true;

  __structuredAttrs = true;

  meta = {
    homepage = "https://fc-solve.shlomifish.org/";
    description = "FreeCell automatic solver";
    longDescription = ''
      FreeCell Solver is a program that automatically solves layouts of Freecell
      and similar variants of Card Solitaire such as Eight Off, Forecell, and
      Seahaven Towers, as well as Simple Simon boards.
    '';
    license = lib.licenses.mit;
    mainProgram = "fc-solve";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,

  bison,
  cmake,
  flex,
  ninja ? null,
  pkg-config,
  python3,

  gtest ? null,
  libffi,
  readline,
  tcl,
  sv-lang ? null,
  zlib,

  gtkwave ? null,
  iverilog ? null,

  symlinkJoin ? null,
  yosys ? null,
  makeWrapper,
  enablePython ? true,
}:

let
  pythonEnv = python3.withPackages (
    pp:
    with pp;
    [ click ]
    ++ lib.optionals enablePython [
      pybind11
      cxxheaderparser
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "yosys";
  version = "0.68";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cf3L3Il717ReAcPTPNHZLwldDeCwuPqHYoxeQusBOOg=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs tests
    substituteInPlace tests/aiger/generate_mk.py \
      --replace-fail 'SHELL := /usr/bin/env bash' 'SHELL := ${stdenv.shell}'
    rm tests/various/plugin.sh tests/various/ezcmdline_plugin.sh
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    bison
    cmake
    cmake.configurePhaseHook
    flex
    pkg-config
    pythonEnv
  ]
  ++ lib.optionals (ninja != null) [ ninja ];

  buildInputs = [
    libffi
    readline
    tcl
    zlib
  ]
  ++ lib.optionals (gtest != null) [ gtest ]
  ++ lib.optionals (sv-lang != null) [ sv-lang ]
  ++ lib.optionals enablePython [
    python3
  ];

  cmakeFlags = [
    (lib.cmakeBool "YOSYS_SKIP_ABC_SUBMODULE_CHECK" true)
    (lib.cmakeFeature "YOSYS_CHECKOUT_INFO" "v${finalAttrs.version}")
    (lib.cmakeBool "YOSYS_WITH_PYTHON" enablePython)
  ]
  ++ lib.optionals enablePython [
    (lib.cmakeBool "YOSYS_INSTALL_PYTHON" true)
    (lib.cmakeFeature "YOSYS_INSTALL_PYTHON_SITEDIR" "${placeholder "out"}/${python3.sitePackages}")
  ];

  checkTarget = "test";
  doCheck = true;
  nativeCheckInputs =
    lib.optionals (gtkwave != null) [ gtkwave ] ++ lib.optionals (iverilog != null) [ iverilog ];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Open RTL synthesis framework and tools";
    homepage = "https://yosyshq.net/yosys/";
    changelog = "https://github.com/YosysHQ/yosys/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    mainProgram = "yosys";
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  perl,
  flex,
  bison,
  python3,
  autoconf,
  which,
  help2man,
  makeWrapper,
  systemc,
  numactl,
  coreutils,
  gdb ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "verilator";
  version = "5.050";

  src = fetchFromGitHub {
    owner = "verilator";
    repo = "verilator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZOwBBbVNP0PaYUvrjdvbWu88fZOZ6IJ8BHAiajcOjP8=";
  };
  enableParallelBuilding = true;
  buildInputs = [
    perl
    systemc
    (python3.withPackages (
      pp: with pp; [
        distro
      ]
    ))
  ];
  nativeBuildInputs = [
    makeWrapper
    flex
    bison
    autoconf
    help2man
  ]
  ++ lib.optionals (gdb != null) [
    gdb
  ];

  nativeCheckInputs = [
    which
    coreutils
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    numactl
  ];

  doCheck = true;
  checkTarget = "test";

  preConfigure = "autoconf";

  postPatch = ''
    patchShebangs bin/* src/* nodist/* docs/bin/* examples/xml_py/* \
    test_regress/{driver.py,t/*.{pl,pf}} \
    test_regress/t/t_a1_first_cc.py \
    test_regress/t/t_a2_first_sc.py \
    ci/* ci/docker/run/* ci/docker/run/hooks/* ci/docker/buildenv/build.sh
    # verilator --gdbbt uses /bin/sh to test if gdb works.
    substituteInPlace bin/verilator --replace-fail "/bin/sh" "${bash}/bin/sh"
  '';

  # This is needed to ensure that the check phase can find the verilator_bin_dbg.
  preCheck = ''
    export PATH=$PWD/bin:$PATH
  '';

  env = {
    VERILATOR_SRC_VERSION = "v${finalAttrs.version}";

    SYSTEMC_INCLUDE = "${lib.getDev systemc}/include";
    SYSTEMC_LIBDIR = "${lib.getLib systemc}/lib";
  };

  meta = {
    changelog = "https://github.com/verilator/verilator/blob/${finalAttrs.src.tag}/Changes";
    description = "Fast and robust (System)Verilog simulator/compiler and linter";
    homepage = "https://www.veripool.org/verilator";
    license = with lib.licenses; [
      lgpl3Only
      artistic2
    ];
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})

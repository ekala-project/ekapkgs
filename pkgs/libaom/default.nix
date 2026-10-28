{
  lib,
  stdenv,
  fetchzip,
  yasm,
  perl,
  cmake,
  pkg-config,
  python3,
  enableVmaf ? true,
  libvmaf,
}:

let
  isCross = stdenv.buildPlatform != stdenv.hostPlatform;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libaom";
  version = "3.15.0";

  src = fetchzip {
    url = "https://aomedia.googlesource.com/aom/+archive/v${finalAttrs.version}.tar.gz";
    hash = "sha256-TixZQP06TEZPtpHvWVOEagzHtXW9hqXWweO2yimBDG4=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    yasm
    perl
    cmake
    cmake.configurePhaseHook
    pkg-config
    python3
  ];

  propagatedBuildInputs = lib.optional enableVmaf libvmaf;

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    NIX_CFLAGS_COMPILE = "-D_POSIX_C_SOURCE=200112L";
  };

  preConfigure = ''
    # build uses `git describe` to set the build version
    cat > $NIX_BUILD_TOP/git << "EOF"
    #!${stdenv.shell}
    echo v${finalAttrs.version}
    EOF
    chmod +x $NIX_BUILD_TOP/git
    export PATH=$NIX_BUILD_TOP:$PATH
  '';

  cmakeEntries = {
    BUILD_SHARED_LIBS = true;
    ENABLE_TESTS = false;
  }
  // lib.optionalAttrs enableVmaf {
    CONFIG_TUNE_VMAF = 1;
  }
  // lib.optionalAttrs (isCross && !stdenv.hostPlatform.isx86) {
    CMAKE_ASM_COMPILER = "${lib.getBin stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isAarch32 {
    ENABLE_NEON = 0;
  };

  # Fix broken paths in .pc file (double slashes)
  postFixup = ''
    substituteInPlace "$dev"/lib/pkgconfig/aom.pc \
      --replace-fail "''${exec_prefix}//" "/"
  '';

  strictDeps = true;

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  meta = {
    description = "Alliance for Open Media AV1 codec library";
    homepage = "https://aomedia.org/av1-features/get-started/";
    changelog = "https://aomedia.googlesource.com/aom/+/refs/tags/v${finalAttrs.version}/CHANGELOG";
    platforms = lib.platforms.all;
    outputsToInstall = [ "bin" ];
    license = lib.licenses.bsd2;
  };
})

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

  outputs = [
    "out"
    "bin"
    "dev"
    "static"
  ];

  patches = [
    ./outputs.patch
  ];

  nativeBuildInputs = [
    yasm
    perl
    cmake
    cmake.configurePhaseHook
    pkg-config
    python3
  ];

  propagatedBuildInputs = lib.optional enableVmaf libvmaf;

  env =
    lib.optionalAttrs stdenv.hostPlatform.isFreeBSD {
      NIX_CFLAGS_COMPILE = "-D_XOPEN_SOURCE=700";
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
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
  };

  cmakeFlags =
    lib.optionals enableVmaf [
      "-DCONFIG_TUNE_VMAF=1"
    ]
    ++ lib.optionals (isCross && !stdenv.hostPlatform.isx86) [
      "-DCMAKE_ASM_COMPILER=${lib.getBin stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch32 [
      "-DENABLE_NEON=0"
    ];

  strictDeps = true;

  postFixup = ''
    moveToOutput lib/libaom.a "$static"
    substituteInPlace "$dev"/lib/cmake/*/*.cmake \
      --replace-quiet "$out/lib/libaom.a" "$static/lib/libaom.a" \
      --replace-quiet "$"'{_IMPORT_PREFIX}/include' "$dev/include"
  ''
  + lib.optionalString stdenv.hostPlatform.isStatic ''
    ln -s $static $out
  '';

  meta = {
    description = "Alliance for Open Media AV1 codec library";
    longDescription = ''
      Libaom is the reference implementation of the AV1 codec from the Alliance
      for Open Media. It contains an AV1 library as well as applications like
      an encoder (aomenc) and a decoder (aomdec).
    '';
    homepage = "https://aomedia.org/av1-features/get-started/";
    changelog = "https://aomedia.googlesource.com/aom/+/refs/tags/v${finalAttrs.version}/CHANGELOG";
    platforms = lib.platforms.all;
    outputsToInstall = [ "bin" ];
    license = lib.licenses.bsd2;
  };
})

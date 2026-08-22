{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  makeWrapper,
  removeReferencesTo,
  runCommand,
  targetPackages,
  cmake,
  ninja,
  llvm_18,
  curl,
  tzdata,
  lit,
  gdb,
  unzip,

  ldcBootstrap ? callPackage ./bootstrap.nix { },
}:

let
  pathConfig = runCommand "ldc-lib-paths" { } ''
    mkdir $out
    echo ${tzdata}/share/zoneinfo/ > $out/TZDatabaseDirFile
    echo ${curl.out}/lib/libcurl${stdenv.hostPlatform.extensions.sharedLibrary} > $out/LibcurlPathFile
  '';

in

stdenv.mkDerivation (finalAttrs: {
  pname = "ldc";
  version = "1.41.0";

  src = fetchFromGitHub {
    owner = "ldc-developers";
    repo = "ldc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6LcpY3LSFK4KgEiGrFp/LONu5Vr+/+vI04wEEpF3s+s=";
    fetchSubmodules = true;
  };

  # https://issues.dlang.org/show_bug.cgi?id=19553
  hardeningDisable = [ "fortify" ];

  postPatch = ''
    patchShebangs runtime tools tests

    rm tests/dmd/fail_compilation/mixin_gc.d
    rm tests/dmd/runnable/xtest46_gc.d
    rm tests/dmd/runnable/testptrref_gc.d

    # test depends on current year
    rm tests/dmd/compilable/ddocYear.d

    substituteInPlace runtime/phobos/std/socket.d --replace-fail "assert(ih.addrList[0] == 0x7F_00_00_01);" ""
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ldcBootstrap
    lit
    lit.python
    llvm_18.dev
    makeWrapper
    ninja
    unzip
    gdb
  ];

  buildInputs = [
    curl
    tzdata
  ];

  outputs = [
    "out"
    "include"
  ];
  outputInclude = "include";

  cmakeFlags = [
    "-DD_FLAGS=-d-version=TZDatabaseDir;-d-version=LibcurlPath;-J${pathConfig}"
    "-DINCLUDE_INSTALL_DIR=${placeholder "include"}/include/d"
  ];

  postConfigure = ''
    export DMD=$PWD/bin/ldmd2
  '';

  makeFlags = [ "DMD=$DMD" ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/ldc2 \
      --prefix PATH : ${targetPackages.stdenv.cc}/bin \
      --set-default CC ${targetPackages.stdenv.cc}/bin/cc
  '';

  preFixup = ''
    find $out/bin -type f -exec ${removeReferencesTo}/bin/remove-references-to -t ${ldcBootstrap} '{}' +
  '';

  disallowedReferences = [ ldcBootstrap ];

  meta = {
    description = "LLVM-based D compiler";
    homepage = "https://github.com/ldc-developers/ldc";
    changelog = "https://github.com/ldc-developers/ldc/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      bsd3
      boost
      mit
      ncsa
      gpl2Plus
    ];
    mainProgram = "ldc2";
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})

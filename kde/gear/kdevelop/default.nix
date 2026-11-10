{
  lib,
  mkKdeDerivation,
  qtwebengine,
  qttools,
  kdevelop-pg-qt,
  pkg-config,
  shared-mime-info,
  apr,
  aprutil,
  boost,
  libastyle,
  llvmPackages,
  subversion,
}:
mkKdeDerivation {
  pname = "kdevelop";

  extraNativeBuildInputs = [
    kdevelop-pg-qt
    pkg-config
    shared-mime-info
  ];

  extraPropagatedBuildInputs = [
    qtwebengine
  ];

  extraBuildInputs = [
    qttools
    apr
    aprutil
    boost
    libastyle
    llvmPackages.libclang
    llvmPackages.libllvm
    subversion
  ];

  extraCmakeFlags = [
    "-DCLANG_BUILTIN_DIR=${lib.getLib llvmPackages.libclang}/lib/clang/${lib.versions.major llvmPackages.libclang.version}/include"
    "-DAPR_CONFIG_PATH=${apr.dev}/bin"
    "-DAPU_CONFIG_PATH=${aprutil.dev}/bin"
  ];
}

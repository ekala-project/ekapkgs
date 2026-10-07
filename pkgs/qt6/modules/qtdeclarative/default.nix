{
  qtModule,
  qtbase,
  qtlanguageserver,
  qtshadertools,
  qtsvg,
  openssl,
  stdenv,
  lib,
  pkgsBuildBuild,
  replaceVars,
  fetchpatch,
}:

qtModule {
  pname = "qtdeclarative";

  propagatedBuildInputs = [
    qtbase
    qtlanguageserver
    qtshadertools
    qtsvg
    openssl
  ];
  strictDeps = true;

  patches = [
    # don't cache bytecode of bare qml files in the store, as that never gets cleaned up
    (replaceVars ./dont-cache-nix-store-paths.patch {
      nixStore = builtins.storeDir;
    })
    # add version specific QML import path
    ./use-versioned-import-path.patch

    # backport fix recommended by KDE
    (fetchpatch {
      url = "https://github.com/qt/qtdeclarative/commit/8a2c82be6ad90e3f2a0760d8bab1e3a8cdb2473a.diff";
      hash = "sha256-3KbyoQPAiRyCwGnwwYV3y0yz2i6UAJcX70EPsXV0ZZM=";
    })

    # backport required at least for [musescore][1], and perhaps many other
    # applications.
    # [1]: https://github.com/musescore/MuseScore/issues/33015
    (fetchpatch {
      url = "https://github.com/qt/qtdeclarative/commit/9d4d376726a6ce15c429128dc65b927e411e40da.diff";
      hash = "sha256-XhfliF5wZuN4/E55f8hfipIRjxBe9V7vL1cgn5p4xqA=";
    })
  ];

  cmakeEntries = {
    Qt6ShaderToolsTools_DIR = "${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderTools";
    Python_EXECUTABLE = "${lib.getExe pkgsBuildBuild.python3}";
  };

  cmakeFlags = # Conditional is required to prevent infinite recursion during a cross build ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
  ];
}

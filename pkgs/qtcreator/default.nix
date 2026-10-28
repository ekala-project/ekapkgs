{
  lib,
  fetchurl,
  cmake,
  pkg-config,
  ninja,
  go,
  python3,
  qt6,
  yaml-cpp,
  litehtml,
  libsecret,
  gumbo,
  llvmPackages_21,
  stdenv' ? llvmPackages_21.stdenv,
  rustc-demangle,
  elfutils,
  perf,
  callPackage,
  buildGoModule,
}:

let
  pname = "qtcreator";
  version = "20.0.1";

  src = fetchurl {
    url = "mirror://qt/official_releases/${pname}/${lib.versions.majorMinor version}/${version}/qt-creator-opensource-src-${version}.tar.xz";
    hash = "sha256-XsO8zwbumhkFqHYKyfunoShWcvFAqX4MUsniSNkFGrg=";
  };

  goModules =
    (buildGoModule {
      pname = "gocmdbridge";
      version = "1.0.0";
      inherit src;
      vendorHash = "sha256-PUMQdVlf6evLjzs263SAecIA3aMuMbjIr1xEztiwmro=";
      setSourceRoot = ''
        sourceRoot=$(echo */src/libs/gocmdbridge/server)
      '';
    }).goModules;
in
stdenv'.mkDerivation {
  inherit pname version src;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    (qt6.qttools.override { withClang = true; })
    qt6.wrapQtAppsHook
    python3
    python3.pkgs.setuptools
    ninja
    go
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdoc
    qt6.qtsvg
    qt6.qtquick3d
    qt6.qtwebengine
    qt6.qtwayland
    qt6.qtserialport
    qt6.qtshadertools
    qt6.qt5compat
    qt6.qtdeclarative
    qt6.qtquicktimeline
    yaml-cpp
    litehtml
    libsecret
    gumbo
    llvmPackages_21.libclang
    llvmPackages_21.llvm
    rustc-demangle
    elfutils
  ];

  cmakeEntries = {
    # workaround for missing CMAKE_INSTALL_DATAROOTDIR
    CMAKE_INSTALL_DATAROOTDIR = "$(out)/share";
    # qtdeclarative in nixpkgs does not provide qmlsc
    QT_NO_FIND_QMLSC = true;
    WITH_DOCS = true;
    BUILD_DEVELOPER_DOCS = true;
    BUILD_QBS = false;
    QTC_CLANG_BUILDMODE_MATCH = true;
    CLANGTOOLING_LINK_CLANG_DYLIB = true;
    CMDBRIDGE_BUILD_VENDOR_MODE = true;
  };

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
    cp -r --reflink=auto ${goModules} src/libs/gocmdbridge/server/vendor
  '';

  qtWrapperArgs = [
    "--set-default PERFPROFILER_PARSER_FILEPATH ${lib.getBin perf}/bin"
  ];

  postInstall = ''
    # Small hack to set-up right prefix in cmake modules for header files
    cmake . $cmakeFlags -DCMAKE_INSTALL_PREFIX="''${!outputDev}"

    cmake --install . --prefix "''${!outputDev}" --component Devel
  '';

  # Remove prefix from the QtC config to make sane output path for 3rd-party plug-ins.
  postFixup = ''
    substituteInPlace ''${!outputDev}/lib/cmake/QtCreator/QtCreatorConfig.cmake --replace "$out/" ""
  '';

  passthru = {
    withPackages = callPackage ./with-plugins.nix { };
  };

  meta = {
    description = "Cross-platform IDE tailored to the needs of Qt developers";
    longDescription = ''
      Qt Creator is a cross-platform IDE (integrated development environment)
      tailored to the needs of Qt developers. It includes features such as an
      advanced code editor, a visual debugger and a GUI designer.
    '';
    homepage = "https://wiki.qt.io/Qt_Creator";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "qtcreator";
  };
}

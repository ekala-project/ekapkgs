{
  stdenv,
  lib,
  fetchFromGitHub,
  kdePackages,
  pkg-config,
  qt6,
  boost,
  libngspice,
  libgit2,
  clipper,
  quazip,
  wrapGAppsHook3,
}:

let
  partsSha = "73bc0559bb8399b2f895d68f032e41d7efc720c0";

  parts = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-parts";
    rev = partsSha;
    hash = "sha256-2aXvSXWjQliEChQGhcCicOVoAqeNdeq69wQVYQsd2ew=";
  };

  svgpp = fetchFromGitHub {
    owner = "svgpp";
    repo = "svgpp";
    tag = "v1.3.1";
    hash = "sha256-nW0ns06XWfUi22nOKZzFKgAOHVIlQqChW8HxUDOFMh4=";
  };
in
stdenv.mkDerivation {
  pname = "fritzing";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-app";
    rev = "04e5bb0241e8f1de24d0fce9be070041c6d5b68e";
    hash = "sha256-JlqBdzWscJoD859KMYgT/af41WNWThP65K3zh2PC2jM=";
  };

  nativeBuildInputs = [
    kdePackages.qmake
    pkg-config
    qt6.qttools
    kdePackages.wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtserialport
    kdePackages.qt5compat
    boost
    libgit2
    quazip
    libngspice
    clipper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ qt6.qtwayland ];

  postPatch = ''
    sed -i "/pri\/quazipdetect.pri/d" phoenix.pro
    sed -i "/pri\/spicedetect.pri/d" phoenix.pro
    substituteInPlace pri/libgit2detect.pri \
      --replace-fail 'LIBGIT_STATIC = true' 'LIBGIT_STATIC = false'
  '';

  qmakeFlags = [
    "PHOENIX_DIR=${parts}"
    "SVGPP_DIR=${svgpp}"
  ];

  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Open-source hardware initiative to make electronics accessible";
    homepage = "https://fritzing.org/";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-sa-30
    ];
    platforms = lib.platforms.linux;
    mainProgram = "Fritzing";
  };
}

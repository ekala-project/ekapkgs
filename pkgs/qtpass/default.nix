{
  stdenv,
  fetchFromGitHub,
  lib,
  qt6,
  git,
  gnupg,
  pass,
  pwgen,
  qrencode,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtpass";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "IJHack";
    repo = "QtPass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6PIQwMtz5Zv+BOmM4BsZwz1btgMsB2+hJieVGERjS6M=";
  };

  postPatch = ''
    substituteInPlace src/qtpass.cpp \
      --replace-fail "/usr/bin/qrencode" "${qrencode}/bin/qrencode"
  '';

  buildInputs = [
    git
    gnupg
    pass
    qt6.qtbase
    qt6.qtsvg
  ];

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ (with qt6; [
    qmake
    qttools
    wrapQtAppsHook
  ]);

  qmakeFlags = [
    "QT_TOOL.lrelease.binary=${lib.getDev qt6.qttools}/bin/lrelease"
    "QMAKE_LUPDATE=${lib.getDev qt6.qttools}/bin/lupdate"
  ];

  qtWrapperArgs = [
    "--suffix PATH : ${
      lib.makeBinPath [
        git
        gnupg
        pass
        pwgen
      ]
    }"
  ];

  postInstall = ''
    install -D qtpass.1 -t $out/share/man/man1
  '';

  meta = {
    description = "Multi-platform GUI for pass, the standard unix password manager";
    mainProgram = "qtpass";
    homepage = "https://qtpass.org";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
})

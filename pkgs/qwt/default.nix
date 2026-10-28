{
  lib,
  stdenv,
  fetchurl,
  qt6,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qwt";
  version = "6.3.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://sourceforge/qwt/qwt-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-3LCFiWwoquxVGMvAjA7itOYK2nrJKdgmOfYYmFGmEpo=";
  };

  patches = [
    ./0001-pkgconfig-for-Qt-5-6-adjustments.patch
  ];

  propagatedBuildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
  ];

  nativeBuildInputs = [
    qt6.qmake
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  postPatch = ''
    sed -e "s|QWT_INSTALL_PREFIX.*=.*|QWT_INSTALL_PREFIX = $out|g" -i qwtconfig.pri
  '';

  qmakeFlags = [ "-after doc.path=$out/share/doc/qwt-${finalAttrs.version}" ];

  dontWrapQtApps = true;

  meta = {
    description = "Qt widgets for technical applications";
    homepage = "http://qwt.sourceforge.net/";
    # LGPL 2.1 plus a few exceptions (more liberal)
    license = with lib.licenses; [
      lgpl21Only
      qwtException
    ];
    platforms = lib.platforms.unix;
  };
})

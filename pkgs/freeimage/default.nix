{
  lib,
  stdenv,
  fetchsvn,
  cctools,
  libtiff,
  libpng,
  zlib,
  libwebp,
  libraw,
  openexr,
  openjpeg,
  libjpeg,
  jxrlib,
  pkg-config,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freeimage";
  version = "3.18.0-unstable-2024-04-18";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/freeimage/svn/";
    rev = "1911";
    hash = "sha256-JznVZUYAbsN4FplnuXxCd/ITBhH7bfGKWXep2A6mius=";
  };

  sourceRoot = "${finalAttrs.src.name}/FreeImage/trunk";

  prePatch = ''
    rm -rf Source/Lib* Source/OpenEXR Source/ZLib
  '';

  patchFlags = [
    "-p1"
    "--binary"
  ];

  patches = [
    ./unbundle.diff
    ./CVE-2020-24292.patch
    ./CVE-2020-24293.patch
    ./CVE-2020-24295.patch
    ./CVE-2021-33367.patch
    ./CVE-2021-40263.patch
    ./CVE-2021-40266.patch
    ./CVE-2023-47995.patch
    ./CVE-2023-47997.patch
  ];

  postPatch = ''
    substituteInPlace Makefile.fip \
      --replace "pkg-config" "$PKG_CONFIG"
    substituteInPlace Makefile.gnu \
      --replace "pkg-config" "$PKG_CONFIG"
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    substituteInPlace Makefile.osx --replace "x86_64" "arm64"
  '';

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    fixDarwinDylibNames
  ];

  buildInputs = [
    libtiff
    libpng
    zlib
    libwebp
    libraw
    openexr
    openjpeg
    libjpeg
    jxrlib
  ];

  postBuild = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    make -f Makefile.fip
  '';

  INCDIR = "$(out)/include";
  INSTALLDIR = "$(out)/lib";

  preInstall = ''
    mkdir -p $INCDIR $INSTALLDIR
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeFlagsArray+=( "INCDIR=$INCDIR" "INSTALLDIR=$INSTALLDIR" )
  '';

  postInstall =
    lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      make -f Makefile.fip install
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      ln -s $out/lib/libfreeimage.3.dylib $out/lib/libfreeimage.dylib
    '';

  meta = {
    description = "Open Source library for accessing popular graphics image file formats";
    homepage = "http://freeimage.sourceforge.net/";
    license = with lib.licenses; [
      freeimage
      gpl2Only
      gpl3Only
    ];
    platforms = lib.platforms.unix;
  };
})

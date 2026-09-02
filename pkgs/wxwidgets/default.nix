{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  expat,
  gspell,
  gtk3,
  libGL,
  libGLU,
  libsm,
  libxinerama,
  libxtst,
  libxxf86vm,
  libnotify,
  libpng,
  libsecret,
  libtiff,
  libjpeg_turbo,
  libxkbcommon,
  zlib,
  pcre2,
  pkg-config,
  xorgproto,
  compat28 ? false,
  compat30 ? true,
  unicode ? true,
  withMesa ? true,
}:

let
  catch = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "Catch";
    rev = "5f5e4cecd1cafc85e109471356dec29e778d2160";
    hash = "sha256-fB/E17tiAicAkq88Je/YFYohJ6EHJOO54oQaqiR/OzY=";
  };

  nanosvg = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "nanosvg";
    rev = "ccdb1995134d340a93fb20e3a3d323ccb3838dd0";
    hash = "sha256-ymziU0NgGqxPOKHwGm0QyEdK/8jL/QYk5UdIQ3Tn8jw=";
  };
in
stdenv.mkDerivation rec {
  pname = "wxwidgets";
  version = "3.2.7.1";

  src = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "wxWidgets";
    rev = "v${version}";
    hash = "sha256-CKU0Aa78YrtGKLE9/MF9VNc2fmzPZ1j4lviX1aAv9cQ=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpng
    libtiff
    libjpeg_turbo
    zlib
    pcre2
    curl
    gspell
    gtk3
    libsm
    libxinerama
    libxtst
    libxxf86vm
    libnotify
    libsecret
    libxkbcommon
    xorgproto
  ]
  ++ lib.optional withMesa libGLU;

  configureFlags = [
    "--disable-precomp-headers"
    "--disable-monolithic"
    "--disable-mediactrl"
    "--with-nanosvg"
    "--disable-rpath"
    "--enable-repro-build"
    "--enable-webrequest"
    "--disable-webview"
    (if compat28 then "--enable-compat28" else "--disable-compat28")
    (if compat30 then "--enable-compat30" else "--disable-compat30")
  ]
  ++ lib.optional unicode "--enable-unicode"
  ++ lib.optional withMesa "--with-opengl"
  ++ [
    "--with-libcurl"
  ];

  SEARCH_LIB = "${libGLU.out}/lib ${libGL.out}/lib";

  preConfigure = ''
    cp -r ${catch}/* 3rdparty/catch/
    cp -r ${nanosvg}/* 3rdparty/nanosvg/
  '';

  postInstall = "
    pushd $out/include
    ln -s wx-*/* .
    popd
  ";

  enableParallelBuilding = true;

  passthru = {
    inherit compat28 compat30 unicode;
  };

  meta = {
    homepage = "https://www.wxwidgets.org/";
    description = "Cross-Platform C++ GUI Library";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
}

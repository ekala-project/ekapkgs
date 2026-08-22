{
  stdenv,
  lib,
  fetchFromGitHub,
  which,
  sqlite,
  lua5_4,
  perl,
  python3,
  zlib,
  pkg-config,
  ncurses,
  pngcrush,
  advancecomp,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "crawl";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "crawl";
    repo = "crawl";
    rev = version;
    hash = "sha256-exntfZbGEDBwFA8AHhOoBPIXw/MDrHx5oxrxPDixpCc=";
  };

  nativeBuildInputs = [
    pkg-config
    which
    perl
    pngcrush
    advancecomp
  ];

  buildInputs = [
    lua5_4
    zlib
    sqlite
    ncurses
  ]
  ++ (with python3.pkgs; [ pyyaml ]);

  preBuild = ''
    cd crawl-ref/source
    echo "${version}" > util/release_ver
    patchShebangs 'util'
    patchShebangs util/gen-mi-enum
    rm -rf contrib
    mkdir -p $out/xdg-data
    mv xdg-data/*_console.* $out/xdg-data
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
    "FORCE_CC=${stdenv.cc.targetPrefix}cc"
    "FORCE_CXX=${stdenv.cc.targetPrefix}c++"
    "HOSTCXX=${buildPackages.stdenv.cc.targetPrefix}c++"
    "FORCE_PKGCONFIG=y"
    "SAVEDIR=~/.crawl"
    "sqlite=${sqlite.dev}"
    "DATADIR=${placeholder "out"}"
  ];

  postInstall = ''
    echo "Exec=crawl" >> $out/xdg-data/org.develz.Crawl_console.desktop
    echo "Icon=crawl" >> $out/xdg-data/org.develz.Crawl_console.desktop
    install -Dm444 $out/xdg-data/org.develz.Crawl_console.desktop -t $out/share/applications
    install -Dm444 $out/xdg-data/org.develz.Crawl_console.appdata.xml -t $out/share/metainfo
    install -Dm444 dat/tiles/stone_soup_icon-512x512.png $out/share/icons/hicolor/512x512/apps/crawl.png
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Open-source, single-player, role-playing roguelike game";
    homepage = "http://crawl.develz.org/";
    license = with lib.licenses; [
      gpl2Plus
      bsd2
      bsd3
      mit
      lib.licenses.zlib
      cc0
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}

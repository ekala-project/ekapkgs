{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  # required
  libiconv,
  libupnp,
  libuuid,
  pugixml,
  spdlog,
  sqlite,
  zlib,
  fmt,
  jsoncpp,
  icu,
  # options
  enableDuktape ? true,
  duktape,
  enableCurl ? true,
  curl,
  enableTaglib ? true,
  taglib,
  enableLibmagic ? true,
  file,
  enableLibmatroska ? true,
  libmatroska,
  libebml,
  enableLibexif ? true,
  libexif,
  enableInotifyTools ? true,
  inotify-tools,
}:

let
  options = [
    {
      name = "CURL";
      enable = enableCurl;
      packages = [ curl ];
    }
    {
      name = "EXIF";
      enable = enableLibexif;
      packages = [ libexif ];
    }
    {
      name = "INOTIFY";
      enable = enableInotifyTools;
      packages = [ inotify-tools ];
    }
    {
      name = "JS";
      enable = enableDuktape;
      packages = [ duktape ];
    }
    {
      name = "MAGIC";
      enable = enableLibmagic;
      packages = [ file ];
    }
    {
      name = "MATROSKA";
      enable = enableLibmatroska;
      packages = [
        libmatroska
        libebml
      ];
    }
    {
      name = "TAGLIB";
      enable = enableTaglib;
      packages = [ taglib ];
    }
  ];

  inherit (lib) flatten;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gerbera";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "gerbera";
    repo = "gerbera";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dszd4WSTjOWwLNha0yq1gtC5kxCrJMhnnhKYaor8JyU=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail /usr/share/bash-completion/completions $out/share/bash-completion/completions
  '';

  cmakeFlags = [
    "-DWITH_SYSTEMD=OFF"
    "-DWITH_MYSQL=OFF"
    "-DWITH_AVCODEC=OFF"
    "-DWITH_EXIV2=OFF"
    "-DWITH_FFMPEGTHUMBNAILER=OFF"
    "-DWITH_WAVPACK=OFF"
  ]
  ++ map (e: "-DWITH_${e.name}=${if e.enable then "ON" else "OFF"}") options;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    libiconv
    libupnp
    libuuid
    pugixml
    spdlog
    sqlite
    zlib
    fmt
    jsoncpp
    icu
  ]
  ++ flatten (builtins.catAttrs "packages" (builtins.filter (e: e.enable) options));

  meta = {
    homepage = "https://docs.gerbera.io/";
    changelog = "https://github.com/gerbera/gerbera/releases/tag/v${finalAttrs.version}";
    description = "UPnP Media Server";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "gerbera";
    broken = true; # missing cstring include in thread_runner.h
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
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
  duktape,
  curl,
  taglib,
  file,
  libmatroska,
  libebml,
  libexif,
  inotify-tools,
}:

let
  libupnp' = libupnp.overrideAttrs (super: {
    cmakeFlags = super.cmakeFlags or [ ] ++ [
      "-Dblocking_tcp_connections=OFF"
      "-Dreuseaddr=ON"
    ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gerbera";
  version = "3.0.0";

  src = fetchFromGitHub {
    repo = "gerbera";
    owner = "gerbera";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-dszd4WSTjOWwLNha0yq1gtC5kxCrJMhnnhKYaor8JyU=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail /usr/share/bash-completion/completions $out/share/bash-completion/completions
  '';

  cmakeFlags = [
    "-DWITH_SYSTEMD=OFF"
    "-DWITH_JS=ON"
    "-DWITH_CURL=ON"
    "-DWITH_TAGLIB=ON"
    "-DWITH_MAGIC=ON"
    "-DWITH_MATROSKA=ON"
    "-DWITH_EXIF=ON"
    "-DWITH_INOTIFY=ON"
    "-DWITH_MYSQL=OFF"
    "-DWITH_AVCODEC=OFF"
    "-DWITH_EXIV2=OFF"
    "-DWITH_FFMPEGTHUMBNAILER=OFF"
    "-DWITH_WAVPACK=OFF"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    libiconv
    libupnp'
    libuuid
    pugixml
    spdlog
    sqlite
    zlib
    fmt
    jsoncpp
    icu
    duktape
    curl
    taglib
    file
    libmatroska
    libebml
    libexif
    inotify-tools
  ];

  meta = {
    homepage = "https://docs.gerbera.io/";
    description = "UPnP Media Server";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "gerbera";
  };
})
